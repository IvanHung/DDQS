function ChToHex(Ch)
{
  return Ch.charCodeAt(0).toString(16);
}

function HexToCh(Hex)
{
  return String.fromCharCode(parseInt(Hex, 16));
}

function StrToHex(Str)
{
  var Ret = '';
  
  for (var i=0; i<Str.length; i++)
    Ret += LPad(ChToHex(Str.charAt(i)), 4, '0');
    
  return Ret;
}

function HexToStr(Hex)
{
  var Ret = '';
  
  for (var i=0; i<Hex.length; i+=4)
    Ret += HexToCh(Hex.substr(i, 4));
    
  return Ret;
}

function NameToFieldID(Name)
{
  if (Name.substr(0, 2) == '__')
    return '__hex_' + StrToHex(Name.substr(2, 255));
  else if (Name.substr(0, 1) == '_')
    return '_hex_' + StrToHex(Name.substr(1, 255));
  else
    return 'hex_' + StrToHex(Name);
}

function FieldIDToName(FieldID)
{
  if ((FieldID.substr(0, 4) == 'hex_') || (FieldID.substr(0, 5) == '_hex_') || (FieldID.substr(0, 6) == '__hex_'))
  {
    if (FieldID.substr(0, 2) == '__')
      return '__' + HexToStr(FieldID.substr(6, 255));
    else if (FieldID.substr(0, 1) == '_')
      return '_' + HexToStr(FieldID.substr(5, 255));
    else
      return HexToStr(FieldID.substr(4, 255));
  }
  else
    return FieldID; 
}


// 是否為全數字
function CheckAllNumber(str)
{
  if ((str != null) && (str != ''))
    for (var i=0; i<str.length; i++)
      if ((str.charAt(i) < '0') || (str.charAt(i) > '9'))
        return false;

  return true;
}

// 是否為大寫英文字
function CheckUpEng(str)
{
  return ((str.charAt(0) >= 'A') && (str.charAt(0) <= 'Z'));
}

// 檢核 IDN 格式
function CheckIDNFormat(str, nationality)
{
  var str = '' + str;
  
  if ((nationality != null) && (nationality != ""))
    return true;
      
  return ((str.length == 10) && CheckUpEng(str.charAt(0)) && 
      ((str.charAt(1) == '1') || (str.charAt(1) == '2')) && 
      CheckAllNumber(''+str.substr(2, 8)));
}

// 檢核 IDN
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

// 檢核 BAN
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

// 填滿字元
function LPad(str, c, ch)
{
  ch = "" + ch;
  str = "" + str;
  for (var i=c-str.length; i>0; i--)
    str = ch + str;
  return str;
}

// 檢查年月日正確性  
function IsValidMonthDay(Year, Month, Day)
{
  switch (Month) 
  {
    case 1: return (Day <= 31);
    case 2:
            if ((Year % 4 == 0) && ((Year % 100 != 0) || (Year % 400 == 0)))
              return (Day <= 29);
            else
              return (Day <= 28);
    case 3: return (Day <= 31);
    case 4: return (Day <= 30);
    case 5: return (Day <= 31);
    case 6: return (Day <= 30);
    case 7: return (Day <= 31);
    case 8: return (Day <= 31);
    case 9: return (Day <= 30);
    case 10: return (Day <= 31);
    case 11: return (Day <= 30);
    case 12: return (Day <= 31);
  }
}
  
// 檢查日期字串  
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

// 取得欄位名稱對應欄位
function CheckItemFromName(Name)
{
  var obj = GetItemFromName(Name);
  
  return ((obj!=null)&&(obj.value!=''));
}

// 取得欄位名稱對應欄位
function GetItemFromName(Name)
{
  eval('var obj = document.all.' + NameToFieldID(Name) + ';');
  if (obj!=null)
    return obj;
    
  for (var i=0; i<mainform.length; i++)
    if (mainform.elements(i).name == Name)
      return mainform.elements(i);

  return null;
}

// 取得欄位名稱對應資料
function GetValueFromName(Name)
{
  obj = GetItemFromName(Name);
  
  if (obj != null)
    return obj.value;
  else
    return '';
}

// 取得相似欄位名稱對應欄位
function GetItemFromNameLike(Name)
{
  for (var i=0; i<mainform.length; i++)
    if (mainform.elements(i).name.substr(0, Name.length) == Name)
      return mainform.elements(i);
      
  return null;
}

function ErrorMsg(Msg, FieldNames)
{
  if (FieldNames == null)
    window.alert(MsgTitle + "\n\n錯誤訊息:\n\n" + Msg);
  else
    window.alert(MsgTitle + "\n\n錯誤訊息:\n\n" + FieldNames + "\n\n" + Msg);
}

// 檢查空白欄位
function RequirePassSomeOne(Names)
{
  var ErrorItemName = null;
  var ErrMsg = "";
    
  for (var i=0; i<Names.length; i+=2)
    if (GetValueFromName(Names[i]) != "")
      return true;
    else
    {
      if (ErrorItemName == null)
        ErrorItemName = Names[i];
      if (ErrMsg == "")
        ErrMsg += "[" + Names[i+1] + "]";
      else
        ErrMsg += ", \n[" + Names[i+1] + "]";
    }
    
  if (ErrMsg != "")
  {
    ErrorMsg("欄位資料不可全部空白.", ErrMsg);
    return (false);
  }

  if ((ErrorItemName != null) && (GetItemFromName(ErrorItemName) != null))
    if (GetItemFromName(ErrorItemName).type != "hidden")
      GetItemFromName(ErrorItemName).focus();
    else
      GetItemFromNameLike('_' + ErrorItemName).focus();
    
  return (ErrMsg == "");
}

// 檢查空白欄位
function RequirePass(Names)
{
  var ErrorItemName = null;
  var ErrMsg = "";
    
  for (var i=0; i<Names.length; i+=2)
    if (GetValueFromName(Names[i]) == "")
    {
      if (ErrorItemName == null)
        ErrorItemName = Names[i];
      if (ErrMsg == "")
        ErrMsg += "[" + Names[i+1] + "]";
      else
        ErrMsg += ", \n[" + Names[i+1] + "]";
    }
    
  if (ErrMsg != "")
  {
    ErrorMsg("欄位資料不可為空白.", ErrMsg);
    return (false);
  }

  if (ErrorItemName != null)
    if (GetItemFromName(ErrorItemName).type != "hidden")
      GetItemFromName(ErrorItemName).focus();
    else
      GetItemFromNameLike('_' + ErrorItemName).focus();
 
  return (ErrMsg == "");
}

// 身分證統一編號檢查  
function IDNCheckPass(IDNField, IDNFieldName, Nationality)
{
  var ErrorItemName = null;
  var ErrMsg = "";
  
  GetItemFromName(IDNField).value = GetValueFromName(IDNField).toUpperCase();
  
  var ChkNationality = '';
  
  if (Nationality != null)
    ChkNationality = '' + GetValueFromName(Nationality);
  
  if ((GetValueFromName(IDNField) != "") && 
      !CheckIDNFormat(GetValueFromName(IDNField), ChkNationality))
  {
    ErrorItemName = IDNField;
    ErrMsg += "[" + IDNFieldName + "]";
  }
  
  if (ErrMsg != "")
  {
    if (Nationality != null)
      ErrorMsg("身分證統一編號欄位資料格式錯誤. 請檢查國籍資料, 若是為外國籍者, 請輸入[國籍]欄位.", ErrMsg);
    else
      ErrorMsg("身分證統一編號欄位資料格式錯誤.", ErrMsg);

    if (ErrorItemName != null)
      if (GetItemFromName(ErrorItemName).type != "hidden")
        GetItemFromName(ErrorItemName).focus();
      else
        GetItemFromNameLike('_' + ErrorItemName).focus();
      
    return (false);
  };
  
  ErrMsg = "";
  
  if (ChkNationality != '')
    return true;
    
  if ((GetValueFromName(IDNField) != "") && 
      !CheckIDN(GetValueFromName(IDNField), ChkNationality))
  {
    ErrorItemName = IDNField;
    ErrMsg += "[" + IDNFieldName + "]";
  }
    
  if (ErrMsg != "")
    if (!window.confirm(MsgTitle + "\n\n錯誤訊息:\n\n" + ErrMsg + "\n\n身分證統一編號欄位資料邏輯檢查錯誤, 請問您要略過嗎?"))
    {
      if (ErrorItemName != null)
        if (GetItemFromName(ErrorItemName).type != "hidden")
          GetItemFromName(ErrorItemName).focus();
        else
          GetItemFromNameLike('_' + ErrorItemName).focus();
        
      return (false);
    }
      
  return (true);
}

// 身分證統一編號檢查  
function IDNCheckHint(IDNField, IDNFieldName)
{
  var ErrorItemName = null;
  var ErrMsg = "";
  
  GetItemFromName(IDNField).value = GetValueFromName(IDNField).toUpperCase();
  
  if ((GetValueFromName(IDNField) != "") && 
      !CheckIDN(GetValueFromName(IDNField)))
  {
    ErrorItemName = IDNField;
    ErrMsg += "[" + IDNFieldName + "]";
  }
  
  if (ErrMsg != "")
    if (!window.confirm(MsgTitle + "\n\n錯誤訊息:\n\n" + ErrMsg + "\n\n身分證統一編號欄位資料邏輯檢查錯誤, 請問您要略過嗎?"))
    {
      if (ErrorItemName != null)
        if (GetItemFromName(ErrorItemName).type != "hidden")
          GetItemFromName(ErrorItemName).focus();
        else
          GetItemFromNameLike('_' + ErrorItemName).focus();
      return (false);
    }
  
  return (true);
}

// 公司統一編號檢查  
function BANCheckPass(BANField, BANFieldName)
{
  return true;
  var ErrorItemName = null;
  var ErrMsg = "";
  
  GetItemFromName(BANField).value = GetValueFromName(BANField).toUpperCase();
  
  if ((GetValueFromName(BANField) != "") && 
      !CheckBAN(GetValueFromName(BANField)))
  {
    ErrorItemName = BANField;
    ErrMsg += "[" + BANFieldName + "]";
  };
  
  if (ErrMsg != "")
  {
    ErrorMsg("公司統一編號欄位資料邏輯檢查錯誤.", ErrMsg);

    if (ErrorItemName != null)
      if (GetItemFromName(ErrorItemName).type != "hidden")
        GetItemFromName(ErrorItemName).focus();
      else
        GetItemFromNameLike('_' + ErrorItemName).focus();
      
    return (false);
  };
  
  return (true);
}
  
// 日期資料檢查
function DateCheckPass(Names)
{
  var ErrorItemName = null;
  var ErrMsg = "";
    
  for (var i=0; i<Names.length; i+=2)
  {
    window.alert(GetValueFromName(Names[i]))
    if (!CheckDateStr(GetValueFromName(Names[i])))
    {
      if (ErrorItemName == null)
        ErrorItemName = Names[i];
      if (ErrMsg == "")
        ErrMsg += "[" + Names[i+1] + "]";
      else
        ErrMsg += ", \n[" + Names[i+1] + "]";
    }
  }
    
  if (ErrMsg != "")
  {
    ErrorMsg("日期欄位資料格式錯誤.", ErrMsg);
    return (false);
  }
      
  if (ErrorItemName != null)
    if (GetItemFromName(ErrorItemName).type != "hidden")
      GetItemFromName(ErrorItemName).focus();
    else
      GetItemFromNameLike('_' + ErrorItemName).focus();
    
  return (ErrMsg == "");
}

function TimeCheckPass(Names)
{
  var ErrorItemName = null;
  var ErrMsg = "";
    
  for (var i=0; i<Names.length; i+=2)
    if (!CheckTimeStr(GetValueFromName(Names[i])))
    {
      if (ErrorItemName == null)
        ErrorItemName = Names[i];
      if (ErrMsg == "")
        ErrMsg += "[" + Names[i+1] + "]";
      else
        ErrMsg += ", \n[" + Names[i+1] + "]";
    }
    
  if (ErrMsg != "")
  {
    ErrorMsg("時間欄位資料格式錯誤.\n\n格式應為[00:00:00~23:59:59].", ErrMsg);
    return (false);
  }  
      
  if (ErrorItemName != null)
    if (GetItemFromName(ErrorItemName).type != "hidden")
      GetItemFromName(ErrorItemName).focus();
    else
      GetItemFromNameLike('_' + ErrorItemName).focus();
    
  return (ErrMsg == "");
}

// 數字欄位檢查
function NumCheckPass(Names)
{
  var ErrorItemName = null;
  var ErrMsg = "";
    
  for (var i=0; i<Names.length; i+=2)
    if (!CheckAllNumber(GetValueFromName(Names[i])))
    {
      if (ErrorItemName == null)
        ErrorItemName = Names[i];
      if (ErrMsg == "")
        ErrMsg += "[" + Names[i+1] + "]";
      else
        ErrMsg += ", \n[" + Names[i+1] + "]";
    }
    
  if (ErrMsg != "")
  {
    ErrorMsg("數字欄位資料格式錯誤.", ErrMsg);
    return (false);
  }
      
  if (ErrorItemName != null)
    if (GetItemFromName(ErrorItemName).type != "hidden")
      GetItemFromName(ErrorItemName).focus();
    else
      GetItemFromNameLike('_' + ErrorItemName).focus();
    
  return (ErrMsg == "");
}

// 自身分證統一編號取得性別
function GetSexFromIDN(Obj, targetObj)
{
  if ((Obj != null) && (targetObj != null))
    if ((''+Obj.value).length > 1)
      if ((''+Obj.value).substr(1, 1) == '2')
        targetObj.value = 'F';
      else if ((''+Obj.value).substr(1, 1) == '1')
        targetObj.value = 'M';
}

function PrintCurPage()
{
  for (var i=0; i<document.all.length; i++)
    if (document.all(i).type == "button" || document.all(i).type == "submit")
      document.all(i).style.display = "none";

  window.print();
  
  for (var i=0; i<document.all.length; i++)
    if (document.all(i).type == "button" || document.all(i).type == "submit")
      document.all(i).style.display = "";
}

function InputVisible(Visible)
{
  for (var i=0; i<document.all.length; i++)
    if (document.all(i).tagName.toLowerCase() == "select")
      document.all(i).style.display = Visible?"":"none";
}