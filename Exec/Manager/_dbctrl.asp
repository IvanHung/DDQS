<%
  var DBConn = null;

  function DoDBConnect()
  {
    if (Session("DBConn")==null)
    {
      try
      {
        DBConn = Server.CreateObject("ADODB.Connection");

        DBConn.ConnectionTimeout = 30;
        DBConn.CommandTimeout = 120;
        DBConn.CursorLocation = 3;

		strConn = "Provider=SQLOLEDB; Data Source="+SysDBHost+";Initial Catalog="+SysDBDatabaseName+"; User Id="+SysDBUser+"; Password="+SysDBPassword;
//		throw new Error(strConn)
        
        DBConn.ConnectionString = strConn;
        DBConn.Open();

        //DBConn.Open("driver={SQL Server};server=" + SysDBHost + ";uid=" + SysDBUser + ";pwd=" + SysDBPassword + ";database=" + SysDBDatabaseName, SysDBUser, SysDBPassword);

        Session('DBConn') = DBConn;
      }
      catch (e)
      {
        Session('DBConn') = null;
        SystemErrorMsg('資料庫開啟失敗. <br> <br>原因:' + e.description);
      }
    }
    else
      DBConn = Session("DBConn");
  }

  function SQLExecute(SQLCmd)
  {
    try
    {
      DoDBConnect();
      return DBConn.Execute(SQLCmd);
    }
    catch (e)
    {
      SQLCmd = ReplaceStrAll(SQLCmd, " from ", " <br>from ");
      SQLCmd = ReplaceStrAll(SQLCmd, " where ", " <br>where<br> ");
      SQLCmd = ReplaceStrAll(SQLCmd, " and ", " <br>and ");
      SQLCmd = ReplaceStrAll(SQLCmd, ",", ",<br>");
      SQLCmd = ReplaceStrAll(SQLCmd, " set ", " <br>set<br> ");

      SystemErrorMsg("執行 SQLExecute() 時發生錯誤. <br> <br>原因:" + e.description + "<br> <br>SQL指令:<br> <br>" + SQLCmd);
    }
  }

  DoDBConnect();

  function ReDBConnect()
  {
    if (Session('DBConn')!=null)
    {
      if (DBConn.State == 1)
        Session('DBConn').Close;
      Session('DBConn') = null;
    }

    DoDBConnect();
  }

  function MakeSQLValue(val)
  {
    val = ReplaceStrAll(val, "'", "' + CHAR(0x27) + '");
    val = ReplaceStrAll(val, '"', "' + CHAR(0x22) + '");

    return val;
  }

  function LogNetCon(cp, item, count)
  {
    if (cp != 'P')
      cp = 'C';
    if (count == null)
      count = 1;

    SQLExecute("exec set_net_condition '" + cp + "', '" + item + "', " + count + "");
  }

  function NewInsertTable(tableName, AllowRowguid)
  {
    if (IsNull(tableName))
      SystemErrorMsg('_dbctrl.asp->InsertTable()作業錯誤: tableName資料不正確.', '系統程式錯誤');
    if (IsNull(Session("user_id")))
      SystemErrorMsg('_dbctrl.asp->InsertTable()作業錯誤: Session("user_id")資料不正確.', '系統程式錯誤');

    SQLExecute("insert into " + tableName +
        " (" + Rcv.GetSqlNamesStr(AllowRowguid) + ") " +
        "values(" + Rcv.GetSqlValuesStr(AllowRowguid) + ")");
  }

  function ModifyInsertTable(tableName)
  {
    if (IsNull(tableName))
      SystemErrorMsg('_dbctrl.asp->InsertTable()作業錯誤: tableName資料不正確.', '系統程式錯誤');
    if (IsNull(Session("user_id")))
      SystemErrorMsg('_dbctrl.asp->InsertTable()作業錯誤: Session("user_id")資料不正確.', '系統程式錯誤');
    if (IsNull(Rcv.Item('rowguid')))
      SystemErrorMsg('_dbctrl.asp->InsertTable()作業錯誤: Rcv.Item("rowguid")資料不正確.', '系統程式錯誤');

    InsertTableFromOldDataAndRcvData(tableName, "rowguid='" + Rcv.Item('rowguid') + "'", new Array('update_user', Session('user_id')), new Array('update_time', 'rowguid'));
  }

  function InsertTableFromOldDataAndRcvData(tableName, WhereCon, DefaultFieldArray, trimFieldArray)
  {
    if (IsNull(tableName))
      SystemErrorMsg('_dbctrl.asp->InsertTableFromOldDataAndRcvData()作業錯誤: tableName資料不正確.', '系統程式錯誤');
    if (IsNull(WhereCon))
      SystemErrorMsg('_dbctrl.asp->InsertTableFromOldDataAndRcvData()作業錯誤: WhereCon資料不正確.', '系統程式錯誤');

    var selectSQL = "select * from " + tableName + " where " + WhereCon +
        "\n and update_time = (\n" +
        "select max(update_time) from " + tableName +
        "\nwhere " + WhereCon +
        "\n)";

    var Qry = SQLExecute(selectSQL);

    if (Qry.eof)
      SystemErrorMsg('資料不存在. SqlCommand:' + selectSQL);

    function GetFieldFromArray(name)
    {
      if (!IsNull(DefaultFieldArray))
        for (var i=0; i<DefaultFieldArray.length; i+=2)
          if (DefaultFieldArray[i] == name)
            return DefaultFieldArray[i+1];

      for (var i=0; i<Rcv.Names.length; i++)
        if (Rcv.Names[i] == name)
          return Rcv.Values[i];

      return null;
    }

    function GetTrimFieldArray(name)
    {
      if (!IsNull(trimFieldArray))
        for (var i=0; i<trimFieldArray.length; i++)
          if (trimFieldArray[i] == name)
            return true;

      return false;
    }

    var FieldNames = "";
    var FieldDatas = "";
    var fieldData = "";

    for (var i = 0; i<Qry.Fields.Count; i++)
    {
      if (!GetTrimFieldArray(Qry.Fields(i).Name))
      {
        if (FieldNames == "")
          FieldNames = "  " + Qry.Fields(i).Name;
        else
          FieldNames = FieldNames + ",\n  " + Qry.Fields(i).Name;

        fieldData = GetFieldFromArray(Qry.Fields(i).Name);

        if (fieldData == null)
          fieldData = Qry.Fields(i);

        if (IsNull(fieldData))
          fieldData = "''";
        else
          fieldData = "'" + fieldData + "'";

        if (FieldDatas == "")
          FieldDatas = "  " + fieldData;
        else
          FieldDatas = FieldDatas + ",\n  " + fieldData;
      }
    }

    SQLExecute("insert into " + tableName +
        "\n(\n" + FieldNames + "\n)\nvalues\n(\n" + FieldDatas + "\n)\n");
  }

  function InsertTableFromOldData(tableName, selectSQL, fieldArray, trimFieldArray)
  {
    if (IsNull(tableName))
      SystemErrorMsg('_dbctrl.asp->InsertTableFromOldData()作業錯誤: tableName資料不正確.', '系統程式錯誤');
    if (IsNull(selectSQL))
      SystemErrorMsg('_dbctrl.asp->InsertTableFromOldData()作業錯誤: selectSQL資料不正確.', '系統程式錯誤');
    if (IsNull(fieldArray))
      SystemErrorMsg('_dbctrl.asp->InsertTableFromOldData()作業錯誤: fieldArray資料不正確.', '系統程式錯誤');

    var Qry = SQLExecute(selectSQL);

    if (Qry.eof)
      SystemErrorMsg('資料不存在. SqlCommand:' + selectSQL);

    function GetFieldFromArray(name)
    {
      for (var i=0; i<fieldArray.length; i+=2)
        if (fieldArray[i] == name)
          return fieldArray[i+1];
      return null;
    }

    function GetTrimFieldArray(name)
    {
      if (!IsNull(trimFieldArray))
        for (var i=0; i<trimFieldArray.length; i++)
          if (trimFieldArray[i] == name)
            return true;
      return false;
    }

    var FieldNames = "";
    var FieldDatas = "";
    var fieldData = "";

    for (var i = 0; i<Qry.Fields.Count; i++)
    {
      if (!GetTrimFieldArray(Qry.Fields(i).Name))
      {
        if (FieldNames == "")
          FieldNames = "  " + Qry.Fields(i).Name;
        else
          FieldNames = FieldNames + ",\n  " + Qry.Fields(i).Name;

        fieldData = GetFieldFromArray(Qry.Fields(i).Name);

        if (fieldData == null)
          fieldData = Qry.Fields(i);

        if (IsNull(fieldData))
          fieldData = "''";
        else
          fieldData = "'" + fieldData + "'";

        if (FieldDatas == "")
          FieldDatas = "  " + fieldData;
        else
          FieldDatas = FieldDatas + ",\n  " + fieldData;
      }
    }

    SQLExecute("insert into " + tableName +
        "\n(\n" + FieldNames + "\n)\nvalues\n(\n" + FieldDatas + "\n)\n");
  }

  function UpdateTable(tableName, WhereCon)
  {
    if (IsNull(tableName))
      SystemErrorMsg('_dbctrl.asp->UpdateTable()作業錯誤: tableName資料不正確.', '系統程式錯誤');

    SQLExecute("update " + tableName + " set " + Rcv.GetSqlUpdateSetStr() + " where " + WhereCon);
  }

  function SelectLastData(tableName, WhereCon)
  {
    if (IsNull(tableName))
      SystemErrorMsg('_dbctrl.asp->SelectLastData()作業錯誤: tableName資料不正確.', '系統程式錯誤');
    if (IsNull(WhereCon))
      SystemErrorMsg('_dbctrl.asp->SelectLastData()作業錯誤: WhereCon資料不正確.', '系統程式錯誤');

    return ("\nand CONVERT(varchar(30), " + tableName + ".update_time, 21) = \n" +
        "(\n" +
        "  select CONVERT(varchar(30), max(update_time), 21) from " + tableName + "\n" +
        "  where " + WhereCon + "\n" +
        ")");
  }

  function GetSelectText(sql, field)
  {
    var TmpQry = SQLExecute(sql);

    if (field == null)
      var Ret = TmpQry(0);
    else
      var Ret = TmpQry(field);

    if (Ret.Type == 135) // 日期型態資料
    {
      if (1*Ret == 0)
        var Ret = "";
      else
        var Ret = "" + ACDateToStr(Ret);// + " " + CHTimeToStr(Qry.Fields(i));
    }
    else
    {
      if (""+Ret == "null")
        var Ret = "";
      else
        var Ret = "" + Ret;
    }


    TmpQry.Close();
    TmpQry = null;

    return Ret;
  }

  function GetSelectCount(sql)
  {
    var TmpQry = SQLExecute(sql);

    var Ret = TmpQry(0)*1;

    TmpQry.Close();
    TmpQry = null;

    return Ret;
  }

  function GetSelectExists(sql)
  {
    var TmpQry = SQLExecute(sql);

    var Ret = !TmpQry.eof;

    TmpQry.Close();
    TmpQry = null;

    return Ret;
  }

  function BrowseLastData(tableName, WhereCon, KeyFieldNameArray)
  {
    if (IsNull(tableName))
      SystemErrorMsg('_dbctrl.asp->BrowseLastData()作業錯誤: tableName資料不正確.');
    if (IsNull(WhereCon))
      SystemErrorMsg('_dbctrl.asp->BrowseLastData()作業錯誤: WhereCon資料不正確.');
    if (IsNull(KeyFieldNameArray))
      SystemErrorMsg('_dbctrl.asp->BrowseLastData()作業錯誤: KeyFieldNameArray資料不正確.');

    var KeyStr = "";
    var GroupStr = "";

    for (var i=0; i<KeyFieldNameArray.length; i++)
      if (KeyStr == "")
      {
        KeyStr = "" + KeyFieldNameArray[i];
        GroupStr = "" + KeyFieldNameArray[i];
      }
      else
      {
        KeyStr = KeyStr + "+" + "" + KeyFieldNameArray[i];
        GroupStr = GroupStr + "," + "" + KeyFieldNameArray[i];
      }

    return ("\nand " + KeyStr + "+CONVERT(varchar(30), " + tableName + ".update_time, 21) in \n" +
        "(\n" +
        "  select " + KeyStr + "+" + "CONVERT(varchar(30), max(update_time), 21) from " + tableName + "\n" +
        "  where " + WhereCon + "\n" +
        "  group by " + GroupStr + "\n" +
        ")");
  }

  function QrySave()
  {
    var FNames = new Array();
    var FValues = new Array();

    function Clear()
    {
      FNames.length = 0;
      FValues.length = 0;
    }

    function Exec(SqlQuery)
    {
      if (IsNull(SqlQuery))
        SystemErrorMsg('_dbctrl.asp->QrySave()->Exec()作業錯誤: SqlQuery資料不正確.', '系統程式錯誤');

      var j = FNames.length;

      Qry = SQLExecute(SqlQuery);

      if (Qry.Eof)
        this.Eof = true;
      else
      {
        this.Eof = false;
        for (var i=0; i<Qry.Fields.Count; i++)
        {
          var Name = "" + Qry.Fields(i).Name;
          if (Qry.Fields(i).Type == 135) // 日期型態資料
          {
            if (1*Qry.Fields(i) == 0)
              var Value = "";
            else
              var Value = "" + ACDateToStr(Qry.Fields(i));// + " " + CHTimeToStr(Qry.Fields(i));
          }
          else
          {
            if (""+Qry.Fields(i) == "null")
              var Value = "";
            else
              var Value = "" + Qry.Fields(i);
          }

          FNames[j] = Name;
          FValues[j] = Value;

          j++;

          Name = null;
          Value = null;
        }
      }

      Qry.Close;
      Qry = null;
    }

    function GetItem(Name)
    {
      for (var i=0; i<FNames.length; i++)
        if (FNames[i] == ""+Name)
          return (FValues[i]);

      return ("");
    }

    function SetItem(Name, Value)
    {
      for (var i=0; i<FNames.length; i++)
        if (FNames[i] == ""+Name)
        {
          FValues[i] = Value;
          return;
        }
      FValues[FNames.length] = Value;
      FNames[FNames.length] = Name;
    }

    this.Eof = true;
    this.Names = FNames;
    this.Values = FValues;
    this.Item = GetItem;
    this.Count = FNames.length;

    this.SetItem = SetItem;
    this.GetItem = GetItem;

    this.Clear = Clear;

    this.Exec = Exec;
  }

  function GetCodeContent(kind, id)
  {
    if (IsNull(kind))
      SystemErrorMsg('_dbctrl.asp->GetCodeContent()作業錯誤: kind資料不正確.');
    if (IsNull(id))
      SystemErrorMsg('_dbctrl.asp->GetCodeContent()作業錯誤: id資料不正確.');

    var RetValue = "";

    var Qry = SQLExecute("select code_content from webap_code " +
        "where code_kind='" + kind + "' and code_id='" + id + "'");

    if (!Qry.Eof)
      RetValue = ""+Qry("code_content");

    Qry.Close;
    Qry = null;

    return RetValue;
  }
%>
