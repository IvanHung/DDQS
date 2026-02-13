<%
  function ResponseMsg(Msg, Subject)
  {
    Response.AppendToLog(SysTitle + "[" + Subject + "]: " + Msg);
    Response.Clear;
    Response.Write("<html>\n<head>\n<title>" + SysTitle + " [" + Subject + "]\n</title>\n</head>\n<body>\n");
    Response.Write("<b>" + SysTitle + "</b><br>\n - " + Subject + " - <br><br>\n" + Request.ServerVariables("URL") + " [" + ACDateToStr() + " " + ACTimeToStr() + "]<br><br>\n");
    Response.Write('<font color=blue style="font-family: 細明體; font-size: 9pt;"><a href="javascript:location.reload()">重新整理</a><br><br>\n');
    Response.Write("訊息細節:\n");
    Response.Write("<br><br><pre>\n\n" + Msg + "\n\n</pre></font>\n\n<br>\n</body>\n</html>");
    Response.End;
  }
  
  function AppendLog(msg, color)
  {
    if (SysLogFilePath != null)
    {
      var fs = Server.CreateObject("Scripting.FileSystemObject");
    
      var LogDateObj = new Date();
  
      try
      {
        if (fs.FolderExists(fs.GetParentFolderName(SysLogFilePath)))
        {
          var outfile = fs.OpenTextFile(SysLogFilePath, 8, true);
    
          var ExtData = "";
          
          if (!IsNull(Session('user_id')))
            ExtData = Session('user_id') + '/' + Session('user_name');
          else
            ExtData = 'Unknow User';
            
          if (color == null)
            color = '#80FF80';
            
          outfile.WriteLine("<!-- [" + ACDateToStr(LogDateObj) + " " + ACTimeToStr(LogDateObj) + "] " + Request.ServerVariables("REMOTE_ADDR") + " -->");
          outfile.WriteLine("     <table border=0 width=100% style=\"border-style:solid;border-width:3;border-color:" + color + ";\">");
          outfile.WriteLine("     <tr bgcolor=" + color + "><td>[" + ACDateToStr(LogDateObj) + " " + ACTimeToStr(LogDateObj) + "] " + Request.ServerVariables("REMOTE_ADDR") + ' ' + ExtData + " " + CurrentUrl() + "</td></tr><tr><td>");
          outfile.WriteLine("     " + msg);
          outfile.WriteLine("     </td></tr></table>");
          outfile.WriteLine("");
          outfile.Close();
          outfile = null;
        }
      }
      catch(e)
      {
      }
      fs = null;
    }
  }
  
  function DeleteLog()
  {
    DeleteFile(SysLogFilePath);
  }

  function ResetLog()
  {  
    if (SysLogFilePath != null)
    {
      var fs = Server.CreateObject("Scripting.FileSystemObject");
    
      try
      {
        if (fs.FolderExists(fs.GetParentFolderName(SysLogFilePath)))
        {
          var logfile = fs.OpenTextFile(SysLogFilePath, 1);
          var AllData = logfile.ReadAll();
          logfile.Close();
    
          if (AllData.length > 2560000)
          {
            var AllData = '' + AllData.substr(AllData.length - 2048000);
    
            var logfile = fs.OpenTextFile(SysLogFilePath, 2, true);
            logfile.Write(AllData);
            logfile.Close();
            logfile = null;
          }
        }
      }
      catch(e)
      {
      }
      fs = null;
    }
  }
  
  function DebugMsg(Msg, Subject)
  {
    if (Subject == null)
      var Subject = "偵錯訊息";
      
    AppendLog("DEBUG <br>Subject:" + Subject + " <br>" + Msg, 'red');
    
    ResponseMsg(Msg, Subject);
  }
  
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
  
  function IsNull(obj)
  {
    var Ret = ((obj == null) || (TrimCh(""+obj) == "") || (""+obj == "undefined") || (""+obj == "null"));
    
    return (Ret == true);
  }
  
  function Nvl(obj, DisplayEmpty)
  {
    if (IsNull(obj))
      return DisplayEmpty;
    else
      return '' + obj;
  }
  
  function LPad(str, c, ch)
  {
    ch = "" + ch;
    str = "" + str;
    
    for (var i=c-str.length; i>0; i--)
      str = ch + str;
      
    return (str);
  }
  
  function RPad(str, c, ch)
  {
    ch = "" + ch;
    str = "" + str;
    
    for (var i=c-str.length; i>0; i--)
      str = str + ch;
      
    return (str);
  }
  
  function TrimCh(str, c)
  {
    return RTrimCh(LTrimCh(str, c), c);
  }
  
  function LTrimCh(str, c)
  {
    var i = 0;
    var nstr = "";
    
    str = "" + str;
    
    if (c == null)
      c = ' ';
      
    for (;i<str.length; i++)
      if (str.charAt(i) != c)
        break;
    for (;i<str.length; i++)
      nstr += str.charAt(i);
      
    return (nstr);
  }
  
  function RTrimCh(str, c)
  {
    var i = str.length - 1;
    var nstr = "";
    
    str = "" + str;
    
    if (c == null)
      c = ' ';
      
    for (;i>=0; i--)
      if (str.charAt(i) != c)
        break;
    for (;i>=0; i--)
      nstr = str.charAt(i) + nstr;
      
    return (nstr);
  }
  
  function NumberToCH(no)
  {
    no = ("" + no).charAt(0);
    switch (no)
    {
      case '0':  return "零"; break;
      case '1':  return "一"; break;
      case '2':  return "二"; break;
      case '3':  return "三"; break;
      case '4':  return "四"; break;
      case '5':  return "五"; break;
      case '6':  return "六"; break;
      case '7':  return "七"; break;
      case '8':  return "八"; break;
      case '9':  return "九"; break;
    }
    return "??";
  }
  
  function GetCurrentMonthStartDateStr()
  {
    var TimeObj = new Date();
      
    return ("" + LPad(TimeObj.getYear(), 4, "0") + '/' + LPad(TimeObj.getMonth()+1, 2, "0") + '/' + LPad("1", 2, "0"));
  }
  
  function GetCurrentMonthEndDateStr()
  {
    var TimeObj = new Date();
      
    return ("" + LPad(TimeObj.getYear(), 4, "0") + '/' + LPad(TimeObj.getMonth()+1, 2, "0") + '/' + LPad(GetDaysOfMonth(TimeObj.getYear()-1911, TimeObj.getMonth()+1), 2, "0"));
  }
  
  function GetCurrentDateStr()
  {
    var TimeObj = new Date();
      
    return ("" + LPad(TimeObj.getYear()-1911, 3, "0") + LPad(TimeObj.getMonth()+1, 2, "0") + LPad(TimeObj.getDate(), 2, "0"));
  }
  
  function DateStrToDateStr7(DateStr)
  {
    var NewDateStr = LPad(DateStr.substr(0, PosStr(DateStr, '/')), 3, '0');
    DateStr = DateStr.substr(PosStr(DateStr, '/')+1, 255);
    NewDateStr += LPad(DateStr.substr(0, PosStr(DateStr, '/')), 2, '0');
    DateStr = DateStr.substr(PosStr(DateStr, '/')+1, 255);
    NewDateStr += LPad(DateStr.substr(0, PosStr(DateStr, ' ')), 2, '0');
    
    return ("" + NewDateStr);
  }
  
  function DateStr7ToDateStr(DateStr)
  {
    if (DateStr == '0000000')
      return "1910/01/01";
    else
      return ("" + (1*LTrimCh(DateStr.substr(0, 3), '0')+1911) + '/' + DateStr.substr(3, 2) + '/' + DateStr.substr(5, 2));
  }
  
  function DateToDateStr7(TimeObj)
  {
    return ("" + LPad(TimeObj.getYear()-1911, 3, "0") + LPad(TimeObj.getMonth()+1, 2, "0") + LPad(TimeObj.getDate(), 2, "0"));
  }
  
  function DateStr7ToDate(DateStr7)
  {
    var Ret = new Date(1911+1*DateStr7.substr(0, 3), 1*DateStr7.substr(3, 2)-1, 1*DateStr7.substr(5, 2));
          
    return Ret;
  }
  
  function GetCurrentYearStr()
  {
    var TimeObj = new Date();
      
    return (TimeObj.getYear()-1911);
  }
  
  function GetCurrentMonthStr()
  {
    var TimeObj = new Date();
      
    return (1+TimeObj.getMonth()*1);
  }
  
  function GetCurrentDayStr()
  {
    var TimeObj = new Date();
      
    return (TimeObj.getDay());
  }
  
  function GetCurrentMStr()
  {
    return ''+LPad(GetCurrentYearStr(), 3, '0')+LPad(GetCurrentMonthStr(), 2, '0');
  }
  
  function ACDateToStr(Tim)
  {
    if (Tim == null)
      var TimeObj = new Date();
    else
      var TimeObj = new Date(Tim);
      
    return ("" + LPad(TimeObj.getYear(), 4, "0") + "/" + LPad(TimeObj.getMonth()+1, 2, "0") + "/" + LPad(TimeObj.getDate(), 2, "0"));
  }
  
  function CHDateToStr(Tim)
  {
    if (Tim == null)
      var TimeObj = new Date();
    else
      var TimeObj = new Date(Tim);
    
    var Year = TimeObj.getYear();
    
    if (Year >= 1911)
      Year -= 1911;
//    if (Year < 1900)
//      Year -= 11;
      
    return ("" + Year + "年" + LPad(TimeObj.getMonth()+1, 2, "0") + "月" + LPad(TimeObj.getDate(), 2, "0") + "日");
  }

  function ACTimeToStr(Tim)
  {
    if (Tim == null)
      var TimeObj = new Date();
    else
      var TimeObj = new Date(Tim);
      
    return ("" + LPad(TimeObj.getHours(), 2, "0") + ":" + LPad(TimeObj.getMinutes(), 2, "0") + ":" + LPad(TimeObj.getSeconds(), 2, "0"));
  }
  
  function CHTimeToStr(Tim)
  {
    if (Tim == null)
      var TimeObj = new Date();
    else
      var TimeObj = new Date(Tim);
      
    return ("" + LPad(TimeObj.getHours(), 2, "0") + ":" + LPad(TimeObj.getMinutes(), 2, "0") + ":" + LPad(TimeObj.getSeconds(), 2, "0"));
  }
  
  function CHDateTimeToStr(Tim)
  {
    if (Tim == null)
      var TimeObj = new Date();
    else
      var TimeObj = new Date(Tim);
      
    return CHDateToStr(Tim) + ' ' + CHTimeToStr(Tim);
  }
  
  function CHDateToFullDateStr(Tim)
  {
    if (Tim == null)
      var TimeObj = new Date();
    else
      var TimeObj = new Date(Tim);
      
    var WeekDay;
    
    if (TimeObj.getDay() == 0)
      WeekDay = '日';
    else
      WeekDay = NumberToCH(TimeObj.getDay());

    return ("" + (TimeObj.getYear()-1911) + "年" + (TimeObj.getMonth()+1) + "月" + TimeObj.getDate() + "日 星期" + WeekDay);
  }
  
  function ACDateStrToDateStr(str)
  {
    var str = ''+str;
    
    return (LTrimCh(1*str.substr(0,4)-1911, '0') + '年' + LTrimCh(str.substr(5,2), '0') + '月' + LTrimCh(str.substr(8,2), '0') + '日');
  }
  
  function CH7DateStrToDateStr(str)
  {
    var str = ''+str;
    
    return (LTrimCh(str.substr(0,3), '0') + '年' + LTrimCh(str.substr(3,2), '0') + '月' + LTrimCh(str.substr(5,2), '0') + '日');
  }
  
  function CH7DateStrToDateWeekStr(str)
  {
    var str = ''+str;
    
    return (LTrimCh(str.substr(0,3), '0') + '年' + LTrimCh(str.substr(3,2), '0') + '月' + LTrimCh(str.substr(5,2), '0') + '日');
  }
  
  function MapCodeName(val, arrayCode)
  {
    if (arrayCode == null)
      return -1;

    for (var i=0; i+1<arrayCode.length; i+=2)
      if (val == ""+arrayCode[i])
        return arrayCode[i+1];
        
    return "[無]";
  }
  
  function FindInArray(arrayVal, val)
  {
    if (arrayVal == null)
      return -1;

    for (var i=0; i<arrayVal.length; i++)
      if (val == ""+arrayVal[i])
        return i;
        
    return -1;
  }
  
  function FindInStr(Str, SubStr)
  {
    return (PosStr(Str, SubStr) > -1)
  }
  
  function PosStr(Str, SubStr)
  {
    if (Str.length < SubStr.length)
      return -1;
    else
    {
      Str = Str.toUpperCase();
      SubStr = SubStr.toUpperCase();
      for (var i=0; i<=Str.length-SubStr.length; i++)
        if (Str.substr(i, SubStr.length) == SubStr)
          return i;
      return -1;
    }
  }
  
  function PosStrCount(Str, SubStr)
  {
    if (Str.length < SubStr.length)
      return 0;
    else
    {
      var PosCount = 0;
      
      Str = Str.toUpperCase();
      SubStr = SubStr.toUpperCase();
      for (var i=0; i<Str.length-SubStr.length; i++)
        if (Str.substr(i, SubStr.length) == SubStr)
          PosCount++;
      return PosCount;
    }
  }
  
  function ReplaceStr(Str, SubStr, NewSubStr)
  {
    return (Str.replace(new RegExp(SubStr, ["i"]), NewSubStr));
  }
  
  function ReplaceStrAll(Str, SubStr, NewSubStr)
  {
    return ((''+Str).replace(new RegExp(''+SubStr, ["ig"]), ''+NewSubStr));
  }
  
  function PGAccessPass(filename)
  {
    if (Session('user_name') != null &&
        Session('login_time') != null &&
        Session('user_id') != null &&
        Session('user_rowguid') != null)
    {
      var fso = new ActiveXObject("Scripting.FileSystemObject");
  
      fileName = "" + filename;
    
      var k;
      
      for (k=fileName.length-1; k>=0; k--)
        if ((k > 0) && (fileName.charAt(k) == '.'))
          break;
          
      for (k=fileName.length-1; k>=0; k--)
        if ((k > 0) && ((fileName.charAt(k) >= '0') && (fileName.charAt(k) <= '9')) && !((fileName.charAt(k-1) >= 'a') && (fileName.charAt(k-1) <= 'z')) )
          break;
    
      if ((fso.GetExtensionName(fileName) == "asp") && 
          (fileName.substring(0, 2) == "pg") && 
          (Session("visible_page") != null))
      {
        var chkfilename = fileName.substr(0, k+1);
      
        var PgArray = Session("visible_page");
        
        for (var i=0; i<PgArray.length; i++)
          if (chkfilename == ""+PgArray[i])
          {
            return true;
            break;
          }
      }
      
      fso = null;
    }
    
    return false;
  }
  
  function GetPageTitle(FileName)
  {
    var fs = Server.CreateObject("Scripting.FileSystemObject");
  
    var Ln = '', Ret = '';
    
    if (fs.FileExists(FileName))
    {
      var htmlfile = fs.OpenTextFile(FileName, 1);
  
      for (var i=0; i<20; i++)
      {
        Ln = htmlfile.ReadLine();
        for (var j=0; j<255; j++)
          if (Ln.substr(j, 12) == "HtmlHeader('")
            for (var k=0; k<255; k++)
              if (Ln.substr(j+k, 3) == "');")
                Ret = Ln.substr(j + 12, k - 12);
      }
      
      htmlfile.Close();
      htmlfile = null;
    }
    
    return Ret;
  }
  
  function MonthDiff(a, b)
  {
    a = a + '';
    b = b + '';
    return ('' + (a.substr(0,3) * 12 + a.substr(3,2) * 1) - (b.substr(0,3) * 12 + b.substr(3,2) * 1));
  }
  
  function SetPagesHome(IsHome)
  {
    if (IsHome == null || IsHome == true)
      Session('PagesHome') = '' + CurrentUrl();
    else
      Session('PagesHome') = null;
  }

  function GetPagesHome()
  {
    return '' + Session('PagesHome');
  }
  
  var Pop3;
  
  function ConnectEMailAccount()
  {
    Pop3 = Server.CreateObject("JMail.POP3");

		try
		{
      Pop3.Connect(SysMailPOP3_LoginID, SysMailPOP3_Password, SysMailPOP3_Host);
    }
    catch (e)
    {
      Pop3 = null;
      SystemErrorMsg("連結到電子郵件信箱[LoginID:" + SysMailPOP3_LoginID + "/POP3 Host:" + SysMailPOP3_Host + "]時, 發生錯誤.<br><br>原因:<br>" + e.description);
    }
  }

  function DisconnectEMailAccount()
  {
    Pop3.disconnect();
    Pop3 = null;
  }
  
  function GetEMailCount()
  {
    return 1*Pop3.Messages.count;
  }
  
  function GetEMail(Index)
  {
    return Pop3.Messages.item(Index);
  }

  function DeleteEMail(Index)
  {
    //return Pop3.DeleteMessages(Index);
  }

  function SendEMail(To, Subject, Body)
  {
    if (DebugMode)
    {
      Subject = To + '* ' + Subject;
      To = 'test@blue-desknote';
    }
    
    To = LTrimCh(RTrimCh(To));

/*    if (To.substr(To.length-12, 12) == "@ntak.gov.tw")
      AdvSendEMail(new Array(To), null, null, Subject, Body, null, From, FromName);
    else*/
    SQLExecute("insert into MAIL_OUTBOX " + 
        "(TO_ADDR, SENDER_ADDR, SENDER_NAME, SUBJECT, BODY, WRITE_DATE) " + 
        "values(" + 
        "  '" + To + "', " + 
        "  '" + SysMailSenderEmail + "', " + 
        "  '" + SysMailSenderName + "', " + 
        "  '" + MakeSQLValue(Subject) + "', " + 
        "  '" + MakeSQLValue(Body) + "', " + 
        "  getdate())");
  }
  
  function AdvSendEMail(To, CC, BCC, Subject, Body, AttachFile, From, FromName)
  {
    if (From == null)
      From = SysMailSenderEmail;
      
    if (FromName == null)
      FromName = SysMailSenderName;
      
//************************************************************************************************

    var JMail = Server.CreateObject("JMail.Message");
    
    JMail.Charset = "big5";
    JMail.ContentTransferEncoding = "base64";
    JMail.Encoding = "base64";
    JMail.ISOEncodeHeaders = false;
    
    JMail.Logging = true;
        
    JMail.From = From;
    JMail.FromName = FromName;
    JMail.Subject = Subject;
    
    if (!IsNull(SysMailSMTP_LoginID))
    {
      JMail.MailServerUserName = SysMailSMTP_LoginID;
      JMail.MailServerPassword = SysMailSMTP_Password;
    }
    
		if (To != null)
		  for (var i=0; i<To.length; i++)
		    JMail.AddRecipient(To[i]);
		    
		if (CC != null)
		  for (var i=0; i<CC.length; i++)
		    JMail.AddRecipientCC(CC[i]);
		
		if (BCC != null)
		  for (var i=0; i<BCC.length; i++)
		    JMail.AddRecipientBCC(BCC[i]);
		    
		if (LTrimCh(Body).substr(0, 6).toLowerCase() == '<html>')
		  JMail.HTMLBody = Body;
		else
		  JMail.Body = Body;
		  
		if (AttachFile != null)
		  for (var i=0; i<AttachFile.length; i++)
  		  JMail.AddAttachment(AttachFile[i]);
		
		try
		{
		  try
		  {
        JMail.Send(SysMailSMTP_Host);
      }
      finally
      {
        JMail.Close();
        JMail = null;
      }
    }
    catch (e)
    {
      SystemErrorMsg("寄送電子郵件[LoginID:" + SysMailSMTP_LoginID + "/SMTP Host:" + SysMailSMTP_Host + "]時發生錯誤.<br><br>原因:<br>" + e.description);
    }
    
//************************************************************************************************    
  }
  
  function ProcessSignData(Title, SubjectName, SourceData, ToAsp)
  {
    var TimeObj = new Date();
    
  	var CM = Server.CreateObject("Persits.CryptoManager");
  	
    CM.LogonUser("", "administrator", "");

    Session('SignDateTime') = LPad(TimeObj.getYear(), 4, "0") + 
        LPad(TimeObj.getMonth()+1, 2, "0") + 
        LPad(TimeObj.getDate(), 2, "0") + 
        '-' + 
        LPad(TimeObj.getHours(), 2, "0") + 
        LPad(TimeObj.getMinutes(), 2, "0") + 
        LPad(TimeObj.getSeconds(), 2, "0");
        
    Session('SignRandomID') = ''+Math.round(Math.random()*999999);
    Session('SignCertCompName') = SysCertCompName;
    Session('SignCertSubjectName') = SubjectName;
    Session('SignSourceData') = '<<台北花市花卉電子交易市集 簽認時間:' + Session('SignDateTime') + ' 資料開始>>\n\n' + 
        SourceData + '\n\n<<台北花市花卉電子交易市集 簽認時間:' + Session('SignDateTime') + ' 資料結束>>';
    Session('ToAsp') = ToAsp;
    Session('SignRcvNames') = Rcv.Names;
    Session('SignRcvValues') = Rcv.Values;
    
    var SourceDataBlob = CM.CreateBlob();
  	SourceDataBlob.Binary = Session('SignSourceData');
%>
<html>
<%
  HtmlHeader(Title);
%>
<body>

<object
  classid="CLSID:F9463571-87CB-4A90-A1AC-2284B7F5AF4E" 
  codeBase="aspencrypt.dll"
  id="XEncrypt">
</object>

<script language="JavaScript">
<!--
  function Sign()
  {
    var Store = XEncrypt.OpenStore("MY", false);

    CertCount = Store.Certificates.Count;

    if (CertCount == 0)
    {
      window.alert("您目前沒有任何憑證, 請於申請憑證後, 再使用本項功能.")
      return;
    }
    
    var TimeObj = new Date();
    var Cert = null;

    if (CertCount == 1)
    {
      Cert = Store.Certificates(1);
      
      if (
          !(
          /*
          (Cert.Subject("CN") == '<%=Session('SignCertSubjectName')%>') &&
          (Cert.Subject("O") == '<%=Session('SignCertCompName')%>') &&
          (Cert.NotBefore <= TimeObj) &&
          (Cert.NotAfter >= TimeObj) &&
          */
          Cert.PrivateKeyExists ) )
      {
        window.alert("您目前沒有 公司 為 <%=Session('SignCertSubjectName')%> 且 主旨名稱 是 <%=Session('SignCertCompName')%> 的有效憑證, 如果您尚未申請, 則請您於重新申請憑證後, 再使用本項功能.");
        return;
      }
    }
    else
    {
  		Cert = XEncrypt.PickCertificate(Store, 4+8+16, "請您選擇所要使用的憑證", "")
  		
      if (Cert == null)
        return;
        
      if (
          !(
          /*
          (Cert.Subject("CN") == '<%=Session('SignCertSubjectName')%>') &&
          (Cert.Subject("O") == '<%=Session('SignCertCompName')%>') &&
          (Cert.NotBefore <= TimeObj) &&
          (Cert.NotAfter >= TimeObj) &&
          */
          Cert.PrivateKeyExists ) )
      {
        window.alert("請選擇 公司 為 <%=Session('SignCertSubjectName')%> 且 主旨名稱 是 <%=Session('SignCertCompName')%> 的有效憑證, 如果您尚未申請, 則請您於重新申請憑證後, 再使用本項功能.");
        return;
      }
    }
      
    if (!window.confirm('系統已索取憑證, 您確定要將資料簽章並傳送至主機, 以進行確認嗎?'))
      return;
    
    var PvkContext = Cert.PrivateKeyContext;
  
    var Hash = PvkContext.CreateHash();
    
    var Blob = XEncrypt.CreateBlob();
    Blob.Base64 = '<%
  Base64Str = SourceDataBlob.Base64;
  for (var i=0; i<Base64Str.length; i++)
    if (Base64Str.charAt(i) > ' ')
      Response.Write(Base64Str.charAt(i));
%>';
    Hash.AddBinary(Blob);
    
    var Blob = Hash.Sign(PvkContext.KeySpec);
    document.all.SignSignatureData.value = Blob.Base64;

//    Cert.ExportToFile('c:\\TFAUser.cer', false);
    var Blob = XEncrypt.CreateBlob();
//    Blob.LoadFromFile('c:\\TFAUser.cer');
    document.all.SignCertData.value = Blob.Base64;
    
    document.all.mainform.submit();
  }
-->
</script>

<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td align="middle" valign="center">
      <b>本筆資料使用數位簽章, 即將使用簽章的數位憑證資料如下:</b><br>
      主旨公司:<%=Session('SignCertCompName')%><br>
      主旨名稱:<%=Session('SignCertSubjectName')%><br>
    </td>
  </tr>
  <tr>
    <td align="middle" valign="center">
      <b>將被簽章的資料明細如下:</b><br>
      <textarea class=readonlytext id="PreviewData" cols=50 rows=20 readonly><%=SourceDataBlob.Binary%></textarea><br>
      <input type="button" class="button" value="確認本筆交易" onClick="Sign();">
      <input type="button" class="button" value="反悔" onClick="history.go(-1);">
      <form action="<%=Session('ToASP')%>" method="post" id="mainform">
      <input type="hidden" id="SignSignatureData" name="SignSignatureData" value="">
      <input type="hidden" id="SignCertData" name="SignCertData" value="">
      </form>
    </td>
  </tr>
</table>

</body>

</html>
<%
  }

  function RecvSignedData()
  {
%>
<--!--METADATA TYPE="TypeLib" UUID="{B72DF063-28A4-11D3-BF19-009027438003}"-->
<%
    
    if ( ExtractFileName(Session('ToASP')) != ExtractFileName(Request.ServerVariables("URL")) )
      ErrorMsg('驗證作業執行錯誤, 位址不正確, 請重新執行.');
      
  	var CM = Server.CreateObject("Persits.CryptoManager");
  	
    CM.LogonUser("", "administrator", "");
  
  	var Context = CM.OpenContext("", true);

    var CertBlob = CM.CreateBlob();
  	CertBlob.Base64 = Request.Form("SignCertData");
  	
    if (CertBlob.Hex.length == 0)
      ErrorMsg('驗證作業執行錯誤, 憑證不正確, 請重新執行.');

  	var Cert = CM.ImportCertFromBlob(CertBlob);
  	
    var TimeObj = new Date();

    /*
    if (!(
        (Cert.Subject("CN") == ''+Session('SignCertSubjectName')) &&
        (Cert.NotBefore <= TimeObj) &&
        (Cert.NotAfter >= TimeObj)
        ) )
      ErrorMsg("請選擇 公司 為 " + Session('SignCertSubjectName') + " 且 主旨名稱 是 " + Session('SignCertCompName') + " 的有效憑證, 如果您尚未申請, 則請您於重新申請憑證後, 再使用本項功能.");
    */
    
  	var PublicKey = Context.ImportKeyFromCert(Cert);
  	
  	var SignedDataBlob = CM.CreateBlob();
  	SignedDataBlob.Base64 = Request.Form("SignSignatureData");
  	
  	var SourceDataBlob = CM.CreateBlob();
  	SourceDataBlob.Binary = '' + Session('SignSourceData');
  	
  	var Hash = Context.CreateHash();
  	Hash.AddBinary(SourceDataBlob);
  	
  	if (!Hash.VerifySignature(SignedDataBlob, PublicKey))
  		ErrorMsg("憑證簽章驗證失敗, 交易作業失敗, 請重新執行.");
  	
//  	var ExFileName = 'C:\\TFASignatureLog\\' + Session('SignDateTime') + '-' + Session('SignRandomID');
    Cert.ExportToFile(ExFileName + '.cer', false);
    
    var fs = Server.CreateObject("Scripting.FileSystemObject");
    var outfile = fs.OpenTextFile(ExFileName + '.signature', 2, true);
    outfile.WriteLine(SignedDataBlob.Base64);
    outfile.Close();
    outfile = null;
    
    var outfile = fs.OpenTextFile(ExFileName + '.content', 2, true);
    outfile.WriteLine(SourceDataBlob.Base64);
    outfile.Close();
    outfile = null;
    
    Hash = null;
    PublicKey = null;
    SourceDataBlob = null;
    SignedDataBlob = null;
    Cert = null;
    
  	var FNames = Session('SignRcvNames');
  	var FValues = Session('SignRcvValues');
    Rcv.SetNewDatas(FNames, FValues);

    Session('SignDateTime') = null;
    Session('SignRandomID') = null;
    Session('SignCertCompName') = null;
    Session('SignCertSubjectName') = null;
    Session('SignData') = null;
    Session('ToAsp') = null;
    Session('SignRcvNames') = null;
    Session('SignRcvValues') = null;
  }
%>
