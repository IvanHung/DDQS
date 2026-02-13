<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('資料維護-稅目維護');
  SetPagesHome();
%>
<body>

<table border="0" class=pagetable cellpadding="1" cellspacing="1" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td nowrap align="center" valign="center" height=20>
<%
  BrowseData("select " +
    " INDEX1, rowguid " +
    " from DDQS_INDEX1 " +
    " order by INDEX1 ",
    new Array(
        'INDEX1'),
    new Array(
        '稅目'),
    'pg9_1_1_d.asp', true, '', '', '');
%>
    </td>
  </tr>
</table>

</body>

</html>
