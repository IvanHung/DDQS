<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('資料維護-項目維護');
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
  if (!IsNull(Rcv.Item('INDEX1_rowguid')) || !IsNull(Rcv.Item('_DO_QUERY')))
    Session('Search_INDEX1') = Rcv.Item('INDEX1_rowguid');

  CreateUI('pg9_1_2.asp', 'mainform', false, false,
      new Array(
      ),
      new Array(
        // 案件內容
        new Array('sqlcombobox', '稅目:', 'INDEX1_rowguid', 'rw', Session('Search_INDEX1'), 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, "onChange='mainform.submit();'"),
        new Array('hidden', '_DO_QUERY', 'true', '')
      )
    );

  BrowseData("select " +
    " INDEX1, INDEX2, DDQS_INDEX2.rowguid " +
    " from DDQS_INDEX2, DDQS_INDEX1 " +
    " where DDQS_INDEX2.INDEX1_rowguid=DDQS_INDEX1.rowguid " +
    " and " + (IsNull(Session('Search_INDEX1'))?"1=1":"INDEX1_rowguid='"+Session('Search_INDEX1')+"'") +
    " order by INDEX1, INDEX2 ",
    new Array('INDEX1', 'INDEX2'),
    new Array('稅目', '項目'),
    'pg9_1_2_d.asp', true, '', '', '');
%>
    </td>
  </tr>
</table>

</body>

</html>
