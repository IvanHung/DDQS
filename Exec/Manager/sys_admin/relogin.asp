<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  ShowMessage('您已進入了不被允許操作的頁面, <BR>或是您已閒置使用本系統超過20分鐘, 請您重新登入.', new Array('重新登入', "top.location.href='../default.asp'"));
%>
