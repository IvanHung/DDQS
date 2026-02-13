<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  HtmlHeader(SysTitle + ' - 登出');

  AppendLog("使用者登出 user_id:" + Session('user_id') + " user_name:" + Session('user_name'));
        
  Session('user_name') = null;
  Session('user_id') = null;
  Session('user_rowguid') = null;
  Session('user_role_id') = null;
  Session('user_cp') = null;
  Session('user_email') = null;

  Session('login_time') = null;
  Session('visible_page') = null;
  
  Session.Abandon;
  
  ShowMessage('您已登出' + SysTitle + '!!', new Array('離開本系統', "top.close();", '重新登入', "parent.location.href='./WindowsADLogin/'"));
%>