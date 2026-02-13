<%
  function GetFindKey(Name, Key)
  {
    var Ret = "";
    var NKey = "";

    if (!IsNull(Key))
    {
      if (Name.substr(Name.length-5, 5) == "__min")
        Ret = Name.substr(0, Name.length-5) + ">='" + Key + "'";
      else if (Name.substr(Name.length-5, 5) == "__max")
        Ret = " (" + Name.substr(0, Name.length-5) + "<='" + Key + "' or " +
              Name.substr(0, Name.length-5) + " like '" + Key + "%') ";
      else if (Key.charAt(Key.length-1) == '!')
        Ret = Name + "='" + Key.substr(0, Key.length-1) + "'";
      else
      {
        for (var i=0; i<Key.length; i++)
          if (Key.charAt(i) == "*")
          {
            if (Ret == "")
              Ret = " like ";
            NKey = NKey + "%";
          }
          else
            NKey = NKey + Key.charAt(i);

        NKey = NKey.toUpperCase();

        if (Ret == "")
        {
          Ret = " (Upper(" + Name + ") like '%" + NKey + "%' or " + Name + " = '" + NKey + "') ";
        }
        else
          Ret = Name + Ret + "'" + NKey + "'";
      }
    }
    else
      Ret = "1=1";

    return (Ret);
  }

  function RcvDataObj()
  {
    var FNames = new Array();
    var FValues = new Array();

    // 設定名稱陣列
    {
      var j=0;

      for (var i=0; i<Request.QueryString.Count; i++)
        FNames[j++] = "" + Request.QueryString.Key(i+1);

      for (var i=0; i<Request.Form.Count; i++)
        FNames[j++] = "" + Request.Form.Key(i+1);

      for (var i=0; i<FNames.length; i++)
        FNames[i] = ReplaceStrAll(FNames[i], '\0', '');
    }

    // 設定變數陣列
    {
      var i = 0;
      var j = 0;

      if (Request.QueryString.Count > 0)
      {
        for (; i<FNames.length; i++)
          if (Request.QueryString(FNames[i]).Count > 0)
          {
            if (FNames[i].substr(FNames[i].length-5, 5) == "_date")
            {
              if (!IsNull(Request.Form(FNames[i])))
                FValues[j++] = "" + LPad(Request.QueryString(FNames[i]), 7, "0");
              else
                FValues[j++] = "";
            }
            else
              FValues[j++] = "" + Request.QueryString(FNames[i]);
          }
          else
            break;
      }

      for (; i<FNames.length; i++)
        if (Request.Form(FNames[i]).Count > 0)
          if (FNames[i].substr(FNames[i].length-5, 5) == "_date")
          {
            if (!IsNull(Request.Form(FNames[i])))
              FValues[j++] = "" + LPad(Request.Form(FNames[i]), 7, "0");
            else
              FValues[j++] = "";
          }
          else
            FValues[j++] = "" + Request.Form(FNames[i]);

      for (i=0; i<FNames.length; i++)
        FNames[i] = FieldIDToName(FNames[i]);
    }

    function CheckItem(Name)
    {
      for (var i=0; i<FNames.length; i++)
        if (FNames[i] == ""+Name)
          return (true);

      return (false);
    }

    function GetItem(Name)
    {
      if (FNames == null)
        ErrorMsg('資料錯誤, 請您重新輸入.');
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

    function GetSqlNamesStr(AllowRowguid)
    {
      var RetNames = "";

      for (var i=0; i<FNames.length; i++)
        if ((FNames[i] != "") && (FNames[i].substr(0, 1) != "_"))
          if (FNames[i] != "update_datetime" && FNames[i] != "update_user_rowguid" && (AllowRowguid == true || FNames[i] != "rowguid"))
          {
            if (RetNames == "")
              RetNames += FNames[i];
            else
              RetNames += "," + FNames[i];
          }

      return (RetNames);
    }

    function GetSqlValuesStr(AllowRowguid)
    {
      var RetValue = "";

      for (var i=0; i<FNames.length; i++)
        if ((FNames[i] != "") && (FNames[i].substr(0, 1) != "_"))
          if (FNames[i] != "update_datetime" && FNames[i] != "update_user_rowguid" && (AllowRowguid == true || FNames[i] != "rowguid"))
          {
            if (RetValue == "")
              RetValue += (FValues[i]==null?"null":"'"+FValues[i]+"'");
            else
              RetValue += "," + (FValues[i]==null?"null":"'"+FValues[i]+"'");
          }

      return (RetValue);
    }

    function GetSqlWhereConStr()
    {
      var RetValue = "";

      for (var i=0; i<FNames.length; i++)
      {
        if ((FNames[i] != "") && (FNames[i].substr(0, 1) != "_") && (FValues[i] != ""))
        {
          if (RetValue == "")
            RetValue += " " + FNames[i] + "='" + FValues[i] + "'";
          else
            RetValue += " and " + FNames[i] + "='" + FValues[i] + "'";
        }
      }

      if (IsNull(RetValue))
        RetValue = " 1=0 ";

      return (RetValue);
    }

    function GetSqlSearchWhereConStr()
    {
      var RetValue = "";

      for (var i=0; i<FNames.length; i++)
        if ((FNames[i] != "") && (FNames[i].substr(0, 1) != "_") && !IsNull(FValues[i]) && (FValues[i] != "") && (FValues[i] != "*"))
          if (RetValue == "")
            RetValue += GetFindKey(FNames[i], FValues[i]);
          else
            RetValue += " and " + GetFindKey(FNames[i], FValues[i]);

      if (IsNull(RetValue))
        RetValue = "1=1";

      RetValue = " (" + RetValue + ") ";

      return (RetValue);
    }

    function GetSqlUpdateSetStr()
    {
      var RetValue = "";
      var Value = "";

      for (var i=0; i<FNames.length; i++)
        if ((FNames[i] != "") && (FNames[i].substr(0, 1) != "_"))
          if (FNames[i] != "update_datetime" && FNames[i] != "update_user_rowguid" && FNames[i] != "rowguid")
          {
            Value = (FValues[i]==null?"null":"'"+MakeSQLValue(FValues[i])+"'");
            if (FNames[i].substr(FNames[i].length-4, 4) == 'DATE')
              if (Value == "''")
                Value = "null";

            if (RetValue == "")
              RetValue += FNames[i] + "=" + Value;
            else
              RetValue += "," + FNames[i] + "=" + Value;
          }

      return (RetValue);
    }

    function GetQuest()
    {
      var Ret = "";

      for (var i=0; i<FNames.length; i++)
        FNames[i] = ReplaceStrAll(FNames[i], '\0', '');

      for (var i=0; i<FNames.length; i++)
        if (FNames[i].charAt(0) != '_')
        {
          if (Ret == "")
            Ret += FNames[i] + "=" + FValues[i];
          else
            Ret += "&" + FNames[i] + "=" + FValues[i];
        }

      return Ret;
    }

    function GetAllQuest()
    {
      var Ret = "";

      for (var i=0; i<FNames.length; i++)
        FNames[i] = ReplaceStrAll(FNames[i], '\0', '');

      for (var i=0; i<FNames.length; i++)
      {
        var Value = '';

        if (Ret == "")
          Ret += FNames[i] + "=" + FValues[i];
        else
          Ret += "&" + FNames[i] + "=" + FValues[i];
      }

      return Ret;
    }

    function Clear()
    {
      FNames = new Array();
      FValues = new Array();
    }

    function SetNewDatas(NewNames, NewValues)
    {
      FNames = null;
      FNames = NewNames;
      FValues = null;
      FValues = NewValues;
      this.Names = FNames;
      this.Values = FValues;
    }

    this.Names = FNames;

    this.Values = FValues;

    this.Item = GetItem;
    this.Count = FNames.length;

    this.SetItem = SetItem;
    this.GetItem = GetItem;

    this.Clear = Clear;

    this.SetNewDatas = SetNewDatas;

    this.CheckItem = CheckItem;

    this.GetSqlNamesStr = GetSqlNamesStr;
    this.GetSqlValuesStr = GetSqlValuesStr;
    this.GetSqlWhereConStr = GetSqlWhereConStr;
    this.GetSqlSearchWhereConStr = GetSqlSearchWhereConStr;
    this.GetSqlUpdateSetStr = GetSqlUpdateSetStr;
    this.GetQuest = GetQuest;
    this.GetAllQuest = GetAllQuest;


    var RcvLog = '';
    for (var i=0; i<FNames.length; i++)
      if (IsNull(RcvLog))
        RcvLog = RcvLog + FNames[i] + "=" + FValues[i];
      else
        RcvLog = RcvLog + "&" + FNames[i] + "=" + FValues[i];

    ///// AppendLog("下載 (RcvLog:" + RcvLog + ")");
  }

  var Rcv = new RcvDataObj();

  function GetValueFromName(Name)
  {
    return Rcv.Item(Name);
  }

  function SaveRCV()
  {
    Session('BackupRcvURL') = ''+CurrentUrl();
    Session('BackupRcvNames') = Rcv.Names;
    Session('BackupRcvValues') = Rcv.Values;
  }

  function HasSavedRCV()
  {
  	return (Session('BackupRcvNames') != null);
  }

  function LoadRCV()
  {
    if (Session('BackupRcvURL') == ''+CurrentUrl())
    {
    	var FNames = Session('BackupRcvNames');
    	var FValues = Session('BackupRcvValues');

    	if (FNames != null && FValues != null)
			Rcv.SetNewDatas(FNames, FValues);
    }
  }

  function ClearSavedRCV()
  {
  	Session('BackupRcvNames') = null;
  	Session('BackupRcvValues') = null;
  }
%>