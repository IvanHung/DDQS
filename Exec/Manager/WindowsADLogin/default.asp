<%@  Language=JavaScript %>
<%
  var LoginUser = ''+Request.ServerVariables("LOGON_USER");
  
  if (LoginUser != null && LoginUser != '')
  {
    LoginUser = LoginUser.substr(LoginUser.length-8, 8);
%>
<html>
<body onload="TransLogon();">
<form id="autologonform" action="../do_login.asp" method="post">
  <input type="hidden" name="_AD_LOGON" value="true">
  <input type="hidden" name="_LOGON_USER_ID" value="<%=LoginUser%>">
</form>
<%    
    
%>
<script language="javascript">
<!--
  function TransLogon()
  {
    autologonform.submit();
  }
//-->
</script>
</body>
</html>
<%
  }
  else
  {
%>
<%=LoginUser%>
<%
  }
    //Response.Redirect('../');
%>
