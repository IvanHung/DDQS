<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  Session('user_name') = null;
  Session('login_time') = null;
  Session('user_id') = null;
  Session('root_menu') = null;
  
  Session.Abandon;
  
  ShowMessage('您已登出' + SysTitle + '!!', new Array('離開本系統', "top.close();", '重新登入', "location.href='../default.asp'"));
%>