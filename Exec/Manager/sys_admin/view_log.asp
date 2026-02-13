<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('系統管理 - 檢視系統紀錄');
%>
<body>

<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td align="middle" nowrap valign="center">
      <iframe src="log.htm" width=100% height=400 id=LogWindow onLoad="LogWindow.scrollBy(0, 99999);"></iframe>
    </td>
  </tr>
  <tr>
    <td align="middle" nowrap valign="center">
      <input class="button" type="button" value="更新" style="width:200px;" onclick="LogWindow.location.reload();">
      <input class="button" type="button" value="回選單頁" style="width:200px;" onclick="location.href='sys_menu.asp'">
    </td>
  </tr>
</table>

</body>

</html>
