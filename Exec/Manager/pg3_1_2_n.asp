<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('行政訴訟裁判書-資料維護-新增');
%>
<body>

<table border="0" class=pagetable cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td nowrap align="middle" valign="center">
<form action="pg3_1_2_nr.asp"  enctype="multipart/form-data" method=post>
  <br>
  <b>請選擇行政訴訟裁判書檔案上傳</b><br><br><input type=file class=text name="word_file"><br><br><br>
  <input type=submit class=button value="檔案上傳">
</form>
    </td>
  </tr>
</table>

</body>

</html>
