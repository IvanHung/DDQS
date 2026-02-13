<%
//  ShowMessage('對不起, 系統更新中, 請稍待一會兒再重新登錄使用.', new Array());

  var fso = new ActiveXObject("Scripting.FileSystemObject");
      
  var CanNotLogin = !PGAccessPass(fso.GetFileName(Request.ServerVariables("URL")));
  
  fso = null;
  
  if (CanNotLogin)
    Response.Redirect("relogin.asp");
%>
