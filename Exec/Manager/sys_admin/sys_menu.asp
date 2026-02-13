<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('系統管理 - 功能選單');
%>
<body>

<table border="0" cellpadding="1" cellspacing="1" width="100%" height="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td align="middle" nowrap valign="center">
      <br>
      <table border=3 cellpadding=2 cellspacing=5 width="80%" height="80%" bgcolor=white borderColor=#8080FF style="margin-bottom: 1px;" >
        <tr>
          <td align=center valign=center nowrap>
            <p align="center"><b><%=SysTitle%></b><br>
            <br>
            <input class="button" type="button" value="角色管理" style="width:200px;" onclick="location.href='role_man.asp'"><br>
            <input class="button" type="button" value="使用者管理" style="width:200px;" onclick="location.href='user_man.asp'"><br>
            <input class="button" type="button" value="代碼管理" style="width:200px;" onclick="location.href='code_man.asp'"><br>
            <input class="button" type="button" value="檢視系統紀錄" style="width:200px;" onclick="location.href='view_log.asp'"><br>
          </tr>
        </td>
      </table>
      <br>
      <input class="button" type="button" value="登出" style="width:200px;" onclick="location.href='logout.asp'"></p>
    </td>
  </tr>
</table>

</body>

</html>
