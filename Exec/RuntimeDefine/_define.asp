<%
  // 偵錯模式 (會顯示程式名稱等資訊)
  DebugMode = false;
  
  // 系統編號
  SysID = "NTAK_DDQS";
  // 系統名稱
  SysTitle = "復查決定書查詢系統";
  // 標題Bar
  SysHeaderBanner = "";
  // 系統版本
  SysVersion = '0.75版 (2004年1月6日)';
  // 首頁URL
  SysHomeURL = 'http://10.14.244.3:8100';
  // 以Windows權限登入頁URL
  SysWindowsUserLoginURL = 'http://10.14.244.3:8100/WindowsADLogin/';

  // 系統根路徑URL
  SysRootPath = "";
  
  // 瀏覽時最大顯示筆數
  SysBrowseCount = 20;
  
  // 系統資料庫 網路位置IP(DomainName)
  SysDBHost = "localhost";
  // 系統資料庫 資料庫名稱
  SysDBDatabaseName = "NTAK_DDQS";
  // 系統資料庫 登入使用者編號
  SysDBUser = "sa";
  // 系統資料庫 登入密碼
  SysDBPassword = "sa";
  
  // 顯示圖示類別
  SysMenuIconClass = 2;
  
  // EMail Pop3 收信網路位置IP(DomainName)
  SysMailPOP3_Host = "blue-desknote";
  // EMail Pop3 登入使用者編號
  SysMailPOP3_LoginID = "test@blue-desknote";
  // EMail Pop3 登入密碼
  SysMailPOP3_Password = "test";
  
  // EMail SMTP 收信網路位置IP(DomainName)
  SysMailSMTP_Host = "blue-desknote";
  // EMail SMTP 登入使用者編號
  SysMailSMTP_LoginID = "test@blue-desknote";
  // EMail SMTP 登入密碼
  SysMailSMTP_Password = "test";
  
  // EMail 預設回信地址
  SysMailReplyEmail = "bmailbox@ntak.gov.tw";
  // EMail 發送地址
  SysMailSenderEmail = "ntak@ntak.gov.tw";
  // EMail 發送人名稱
  SysMailSenderName = "財政部高雄市國稅局";

  // 局長名稱  
  SysORGManagerName = "鄭宗典";
  
  // 系統憑證發證者名稱
  SysCertIssuerName = "發證者";
  // 系統憑證公司名稱
  SysCertCompName = "憑證所屬公司";

  // 系統紀錄檔位置  
  SysLogFilePath = "D:\\WWW_ROOT\\NTAK_DDQS\\Exec\\Manager\\sys_admin\\log.htm";
  
  // 系統網頁頁首資訊
  SysHtmlHeader = "  <meta HTTP-EQUIV=Content-Language Content=zh-tw>\n" + 
    "  <meta HTTP-EQUIV=Content-Type Content='text/html; charset=big5'>\n" + 
    "  <link HREF=" + SysRootPath + "/default.css REL=stylesheet TYPE=text/css>";
%>
