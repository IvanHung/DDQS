<%
  /***************************************************************************
  程式庫名稱          (Library Name):
  此程式庫用途描述(Library Descript):
  程式庫版本               (Version):2001.01.12.001
  程式庫撰寫人            (Build By):陳浩威
  建立日期             (Create Date):
  所使用的系統環境            (O.S.):Ms Windows
  所使用的程式語言        (LANGUAGE):JavaScript
  建立檔案名稱    (Create File Name):_chkfunc.asp
  *--------------------------------------------------------------
  程式庫修改或更新者     (Modify By):
  程式庫修改或更新日期 (Modify Date):
  *--------------------------------------------------------------
  [程式庫所屬的基本函數說明]
  [主項目-次項目編號]=[說              明]===============
     [001-001]
     ----------------------------------------------
     [002-003]
  ***************************************************************************/

  function CheckAllNumber(str)
  {
    if (!IsNull(str))
      for (var i=0; i<str.length; i++)
        if ((str.charAt(i) < "0") || (str.charAt(i) > "9"))
          return false;

    return true;
  }

  function CheckUpEng(str)
  {
    return ((str.charAt(0) >= "A") && (str.charAt(0) <= "Z"));
  }

  function CheckIDNFormat(str, nationality)
  {
    if ((nationality != null) && (nationality != ""))
      return true;

    return ((str.length == 10) && CheckUpEng(""+str.charAt(0)) &&
        ((str.charAt(1) == "1") || (str.charAt(1) == "2")) &&
        CheckAllNumber(""+str.substr(2, 8)));
  }

  function CheckIDN(str, nationality)
  {
    if (CheckIDNFormat(str, nationality))
    {
      var X = 0;
      var ShiftKey = new Array(10,11,12,13,14,15,16,17,34,18,19,20,21,
          22,35,23,24,25,26,27,28,29,32,30,31,33);

      X = ShiftKey[str.charCodeAt(0)-65];
      X = 0 + Math.floor(X / 10) + 9 * (X % 10) +
          8 * str.charAt(1) + 7 * str.charAt(2) +
          6 * str.charAt(3) + 5 * str.charAt(4) +
          4 * str.charAt(5) + 3 * str.charAt(6) +
          2 * str.charAt(7) + 1 * str.charAt(8) +
          1 * str.charAt(9);

      return (0 == (X % 10));
    }
    else
      return (false);
  }
  
  function CheckBAN(str)
  {
    var C1,C2,C3,C4,A1,A2,A3,A4,B1,B2,B3,B4,A5, Ret;

    if (CheckAllNumber(str))
    {
      C1 = str.charAt(0)*1;
      C2 = str.charAt(2)*1;
      C3 = str.charAt(4)*1;
      C4 = str.charAt(7)*1;
      A1 = Math.floor(str.charAt(1) * 2 / 10);
      B1 = str.charAt(1) * 2 % 10;
      A2 = Math.floor(str.charAt(3) * 2 / 10);
      B2 = str.charAt(3) * 2 % 10;
      A3 = Math.floor(str.charAt(5) * 2 / 10);
      B3 = str.charAt(5) * 2 % 10;
      A4 = Math.floor(str.charAt(6) * 4 / 10);
      B4 = str.charAt(6) * 4 % 10;
      Ret = (C1+C2+C3+C4+A1+A2+A3+A4+B1+B2+B3+B4) % 10 == 0;
      
      if (!Ret && (str.charAt(6)=='7'))
      {
        A5 = Math.floor((A4+B4) / 10);
        Ret = ((a1+b1+c1+a2+b2+c2+a3+b3+c3+a5+c4) % 10 == 0);
      }
    }
    else
      return(false);
      
    return(Ret);
  }
  
  function GetDaysOfMonth(Year, Month)
  {
    switch (Month)
    {
      case 1: return (31);
      case 2:
              if ((Year % 4 == 0) && ((Year % 100 != 0) || (Year % 400 == 0)))
                return (29);
              else
                return (28);
      case 3: return (31);
      case 4: return (30);
      case 5: return (31);
      case 6: return (30);
      case 7: return (31);
      case 8: return (31);
      case 9: return (30);
      case 10: return (31);
      case 11: return (30);
      case 12: return (31);
    }
  }

  function IsValidMonthDay(Year, Month, Day)
  {
    return (Day <= GetDaysOfMonth(Year, Month));
  }

  function GetAge(IDNField, IDNFieldName)
  {
    var TimeObj = new Date();
    
    return TimeObj.getYear()-1911 - Rcv.Item(IDNField).substr(0, 3)*1 ;
  }
  
  function CheckDateStr(str)
  {
    str = "" + str;
    
    if (str.length == 0)
      return true;
    else if ((str.length != 10) || !CheckAllNumber(str.substr(0, 4)) || !CheckAllNumber(str.substr(5, 2)) || !CheckAllNumber(str.substr(8, 2)))
      return false;
    else if ((str.substr(0, 4)*1 < 1000) || (str.substr(0, 4)*1 > 3000))
      return false;
    else if ((str.substr(5, 2)*1 < 1) || (str.substr(5, 2)*1 > 12))
      return false;
    else if ((str.substr(8, 2)*1 < 1) || !IsValidMonthDay(str.substr(0, 4)*1, str.substr(5, 2)*1, str.substr(8, 2)*1))
      return false;
    else
      return true;
  }

  function CheckTimeStr(str)
  {
    str = "" + str;
    
    if (str.length == 0)
      return true;
    else if ((str.length != 8) || !CheckAllNumber(str.substr(0, 2)) || !CheckAllNumber(str.substr(3, 2)) || !CheckAllNumber(str.substr(6, 2)))
      return false;
    else if ((str.substr(0, 2)*1 < 0) || (str.substr(0, 2)*1 > 23))
      return false;
    else if ((str.substr(3, 2)*1 < 0) || (str.substr(3, 2)*1 > 59))
      return false;
    else if ((str.substr(6, 2)*1 < 0) || (str.substr(6, 2)*1 > 59))
      return false;
    else
      return true;
  }

  function UniquePass(tableName, Names, IgnoreSameRecord)
  {
    var RetValue = false;

    if (!IsNull(tableName))
    {
      var WhereCons = "";

      for (var i=0; i<Names.length; i+=2)
      {
        if (WhereCons == "")
          WhereCons += Names[i] + "='" + Rcv.Item(Names[i]) + "' ";
        else
          WhereCons += "and " + Names[i] + "='" + Rcv.Item(Names[i]) + "' ";
      };
      
      if (IgnoreSameRecord && !IsNull(Rcv.Item('rowguid')))
        if (WhereCons == "")
          WhereCons += "rowguid <> '" + Rcv.Item('rowguid') + "' ";
        else
          WhereCons += "and " + "rowguid <> '" + Rcv.Item('rowguid') + "'";

      var Qry = SQLExecute("select count(*) from " + tableName + " where " + WhereCons);
      RetValue = Qry(0) == 0;

      Qry.Close;
      Qry = null;
    }

    if (!RetValue)
    {
      var ErrMsg = "";

      for (var i=0; i<Names.length; i+=2)
      {
        if (ErrMsg == "")
          ErrMsg += "[" + Names[i+1] + "] = '" + Rcv.Item(Names[i]) + "'";
        else
          ErrMsg += " 及<br>[" + Names[i+1] + "] = '" + Rcv.Item(Names[i]) + "'";
      };

      ErrorMsg(ErrMsg + "<br>資料已經存在.");
    }

    return (RetValue);
  }

  function RequirePassSomeOne(Names)
  {
    var ErrMsg = "";
    var Err = true;

    for (var i=0; i<Names.length; i+=2)
    {
      if (!IsNull(Rcv.Item(Names[i])))
        return true;
      else if (ErrMsg == "")
        ErrMsg += "[" + Names[i+1] + "]";
      else
        ErrMsg += ", <br>[" + Names[i+1] + "]";
    }

    if (!IsNull(ErrMsg))
      ErrorMsg(ErrMsg + "<br>欄位資料不可為均為空白.");

    return (IsNull(ErrMsg));
  }

  function RequirePass(Names)
  {
    var ErrMsg = "";

    for (var i=0; i<Names.length; i+=2)
      if (IsNull(Rcv.Item(Names[i])))
        if (ErrMsg == "")
          ErrMsg += "[" + Names[i+1] + "]";
        else
          ErrMsg += ", <br>[" + Names[i+1] + "]";

    if (!IsNull(ErrMsg))
      ErrorMsg(ErrMsg + "<br><br>欄位資料不可為空白.");

    return (IsNull(ErrMsg));
  }

  function RequirePassArray(Names, ExpressionStr)
  {
    if (ExpressionStr == null)
      DebugMsg('RequirePassArray 之 ExpressionStr 必須輸入.');

    var ErrMsg = "";

    for (var colno=0, k=1; colno<MaxUIArrayCount; colno++, k++)
    {
      if (!eval(ExpressionStr))
        continue;
        
      for (var i=0; i<Names.length; i+=2)
        if (IsNull(Rcv.Item(Names[i]+colno)))
          if (ErrMsg == "")
            ErrMsg += "第" + k + "行<br>[" + Names[i+1] + "]";
          else
            ErrMsg += ", <br>[" + Names[i+1] + "]";
  
      if (!IsNull(ErrMsg))
      {
        ErrorMsg(ErrMsg + "<br><br>欄位資料不可為空白.");
        break;
      }
    }
    
    return (IsNull(ErrMsg));
  }

  function IDNCheckPass(IDNField, IDNFieldName, Nationality)
  {
    var ErrMsg = "";

    Rcv.SetItem(IDNField, Rcv.Item(IDNField).toUpperCase());

    if ((Rcv.Item(IDNField) != "") && !CheckIDNFormat(Rcv.Item(IDNField), Rcv.Item(Nationality)))
      ErrMsg += "[" + IDNFieldName + "]";

    if (!IsNull(ErrMsg))
      ErrorMsg(ErrMsg + "<br>身分證統一編號欄位資料格式錯誤.");

    return (IsNull(ErrMsg));
  }
  
  function IDNCheckHint(IDNField, IDNFieldName)
  {
    return (true);
  }

  function BANCheckPass(BANField, BANFieldName)
  {
    var ErrMsg = "";

    Rcv.SetItem(BANField, Rcv.Item(BANField).toUpperCase());

    if ((Rcv.Item(BANField) != "") && !CheckBAN(Rcv.Item(BANField)))
      ErrMsg += "[" + BANFieldName + "]";

    if (!IsNull(ErrMsg))
      ErrorMsg(ErrMsg + "<br>公司統一編號欄位資料邏輯檢查錯誤.");

    return (IsNull(ErrMsg));
  }

  function DateCheckPass(Names)
  {
    var ErrMsg = "";

    for (var i=0; i<Names.length; i+=2)
      if (!CheckDateStr(Rcv.Item(Names[i])))
        if (ErrMsg == "")
          ErrMsg += "[" + Names[i+1] + "]";
        else
          ErrMsg += ", <br>[" + Names[i+1] + "]";

    if (!IsNull(ErrMsg))
      ErrorMsg(ErrMsg + "<br><br>日期欄位資料格式錯誤.");

    return (IsNull(ErrMsg));
  }

  function DateCheckPassArray(Names, ExpressionStr)
  {
    if (ExpressionStr == null)
      DebugMsg('DateCheckPassArray 之 ExpressionStr 必須輸入.');

    var ErrMsg = "";

    for (var colno=0, k=1; colno<MaxUIArrayCount; colno++, k++)
    {
      if (!eval(ExpressionStr))
        continue;
        
      for (var i=0; i<Names.length; i+=2)
        if (!CheckDateStr(Rcv.Item(Names[i]+colno)))
          if (ErrMsg == "")
            ErrMsg += "第" + k + "行<br>[" + Names[i+1] + "]";
          else
            ErrMsg += ", <br>[" + Names[i+1] + "]";
  
      if (!IsNull(ErrMsg))
        ErrorMsg(ErrMsg + "<br><br>日期欄位資料格式錯誤.");
    }
    return (IsNull(ErrMsg));
  }

  function TimeCheckPass(Names)
  {
    var ErrMsg = "";

    for (var i=0; i<Names.length; i+=2)
      if (!CheckTimeStr(Rcv.Item(Names[i])))
        if (ErrMsg == "")
          ErrMsg += "[" + Names[i+1] + "]";
        else
          ErrMsg += ", <br>[" + Names[i+1] + "]";

    if (!IsNull(ErrMsg))
      ErrorMsg(ErrMsg + "<br><br>時間欄位資料格式錯誤.");

    return (IsNull(ErrMsg));
  }

  function NumCheckPass(Names)
  {
    var ErrMsg = "";

    for (var i=0; i<Names.length; i+=2)
      if (!CheckAllNumber(Rcv.Item(Names[i])))
        if (ErrMsg == "")
          ErrMsg += "[" + Names[i+1] + "]";
        else
          ErrMsg += ", <br>[" + Names[i+1] + "]";

    if (!IsNull(ErrMsg))
      ErrorMsg(ErrMsg + "<br><br>數字欄位資料格式錯誤.");

    return (IsNull(ErrMsg));
  }
  
  function NumCheckPassArray(Names, ExpressionStr)
  {
    if (ExpressionStr == null)
      DebugMsg('NumCheckPassArray 之 ExpressionStr 必須輸入.');
      
    var ErrMsg = "";

    for (var colno=0, k=1; colno<MaxUIArrayCount; colno++, k++)
    {
      if (!eval(ExpressionStr))
        continue;
        
      for (var i=0; i<Names.length; i+=2)
        if (!CheckAllNumber(Rcv.Item(Names[i]+colno)))
          if (ErrMsg == "")
            ErrMsg += "第" + k + "行<br>[" + Names[i+1] + "]";
          else
            ErrMsg += ", <br>[" + Names[i+1] + "]";
  
      if (!IsNull(ErrMsg))
        ErrorMsg(ErrMsg + "<br><br>數字欄位資料格式錯誤.");
    }
    return (IsNull(ErrMsg));
  }
%>
