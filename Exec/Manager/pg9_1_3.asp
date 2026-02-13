<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('資料維護-關鍵字維護');
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
  if (!IsNull(Rcv.Item('INDEX2_rowguid')) || !IsNull(Rcv.Item('_DO_QUERY')))
    Session('Search_INDEX2') = Rcv.Item('INDEX2_rowguid');
  if (IsNull(Session('Search_INDEX1')))
    Session('Search_INDEX2') = '';

  CreateUI('pg9_1_3.asp', 'mainform', false, true,
      new Array(
      ),
      new Array(
        // 案件內容
        new Array('sqlcombobox', '稅目:', 'INDEX1_rowguid', 'rw', Session('Search_INDEX1'), 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, "onChange='mainform.submit();'"),
        new Array('sqlcombobox', '項目:', 'INDEX2_rowguid', 'rw', Session('Search_INDEX2'), 'rowguid', 'INDEX2', "select * from DDQS_INDEX2 " +
            "where " + (IsNull(Session('Search_INDEX1'))?"1=0":"INDEX1_rowguid='" + Session('Search_INDEX1') + "'") + " order by INDEX2", true, "onChange='mainform.submit();'"),
        new Array('hidden', '_DO_QUERY', 'true', '')
      )
    );

  BrowseData("select " +
    " INDEX1, INDEX2, KEYS, DDQS_KEYS.rowguid " +
    " from DDQS_KEYS, DDQS_INDEX2, DDQS_INDEX1 " +
    " where DDQS_KEYS.INDEX2_rowguid=DDQS_INDEX2.rowguid " +
    " and DDQS_INDEX2.INDEX1_rowguid=DDQS_INDEX1.rowguid " +
    " and " + (IsNull(Session('Search_INDEX1'))?"1=1":"INDEX1_rowguid='"+Session('Search_INDEX1')+"'") +
    " and " + (IsNull(Session('Search_INDEX2'))?"1=1":"INDEX2_rowguid='"+Session('Search_INDEX2')+"'") +
    " order by INDEX1, INDEX2, KEYS ",
    new Array('INDEX1', 'INDEX2', 'KEYS'),
    new Array('稅目', '項目', '關鍵字'),
    'pg9_1_3_d.asp', true, '', '', '');
%>
    </td>
  </tr>
</table>

</body>

</html>
