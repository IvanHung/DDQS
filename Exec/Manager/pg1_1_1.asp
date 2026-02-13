<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('復查決定書-資料查詢');
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
  if (!IsNull(Rcv.Item('_DO_QUERY')))
    SaveRCV();
  else
    LoadRCV();

  if (Rcv.Item('_action') == '清除查詢條件')
    Rcv.Clear();

  CreateUI('pg1_1_1.asp', 'mainform', false, true,
      new Array(
        'submit', '查詢',
        'submit', '清除查詢條件'
      ),
      new Array(
        new Array('space', '<font color=white>查詢條件</font>'),
        new Array('sqlcombobox', '稅目:', 'INDEX1_idx', 'rw', Rcv.Item('INDEX1_idx'), 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, "onChange='mainform.submit();'"),
        new Array('sqlcombobox', '復查項目:', '_INDEX2_idx', 'rw', Rcv.Item('_INDEX2_idx'), 'rowguid', 'INDEX2', "select * from DDQS_INDEX2 " +
            "where " + (IsNull(Rcv.Item('INDEX1_idx'))?"1=0":"INDEX1_rowguid='" + Rcv.Item('INDEX1_idx') + "'") + " order by INDEX2", true, "onChange='mainform.submit();'"),
        new Array('sqlcombobox', '關鍵字:', '_KEY', 'rw', Rcv.Item('KEYS'), 'KEYS', 'KEYS', "select KEYS from DDQS_KEYS " +
            "where " + (IsNull(Rcv.Item('_INDEX2_idx'))?"1=0":"INDEX2_rowguid='" + Rcv.Item('_INDEX2_idx') + "'") + " order by KEYS", true, "onChange='mainform.submit();'"),
        new Array('text', '文號:', 'DOCNO', 'rw', '', 20, 20, ''),
        new Array('chdate_range', '發文日期:', 'SEND_DATE', 'rw', '', '', ''),
        new Array('text', '統一編號:', 'IDNO', 'rw', '', 10, 10, ''),
        new Array('text', '檢索鍵值:', '_SKEY', 'rw', '', 60, 60, ''),
        new Array('hidden', '_DO_QUERY', 'true', '')
      ),
      new Array(
        '', 2,
        '', 1,
        'sameline', 1,
        '', 2,
        '', 1,
        'sameline', 1,
        '', 2,
        '', 2
      )
    );
%>
    </td>
  </tr>
</table>
<%
  if (!IsNull(Rcv.Item('_DO_QUERY')) || !IsNull(Rcv.Item('_BrowseLocation')))
  {
    var WhereCon = Rcv.GetSqlSearchWhereConStr();

    WhereCon += " and DOC_TYPE = '1' ";

    if (!IsNull(Rcv.Item('_INDEX2_idx')))
      WhereCon += " and INDEX2_LIST like '%" + GetSelectText("select INDEX2 from DDQS_INDEX2 where rowguid='" + Rcv.Item('_INDEX2_idx') + "'") + "%' ";

    if (!IsNull(Rcv.Item('_KEY')))
      WhereCon += " and KEY_LIST like '%" + Rcv.Item('_KEY') + "%' ";

    if (!IsNull(Rcv.Item('_SKEY')))
    {
      Rcv.SetItem('_SKEY', ReplaceStrAll(Rcv.Item('_SKEY'), ' ', '%'));
      WhereCon += " and (KEY_LIST like '%" + Rcv.Item('_SKEY') + "%' or DOC like '%" + Rcv.Item('_SKEY') + "%') ";
    }

    Session('SEARCH1_WhereCon') = WhereCon;
    Session('SEARCH1_Order') = " SEND_DATE desc ";

    if (!IsNull(Session('SEARCH1_RowGuids')))
    {
      Session('SEARCH1_RowGuids').Close();
      Session('SEARCH1_RowGuids') = null;
    }

    Session('SEARCH1_RowGuids') =
        SQLExecute("select " +
          " DDQS_DOC.rowguid " +
          " from DDQS_DOC, DDQS_INDEX1 " +
          " where " + Session('SEARCH1_WhereCon') +
          " and DDQS_DOC.INDEX1_idx=DDQS_INDEX1.rowguid " +
          " order by " + Session('SEARCH1_Order'));
  }

  if (!IsNull(Session('SEARCH1_WhereCon')))
  {
    BrowseData("select " +
      " DOC_TYPE, DOCNO, IDNO, INDEX1, REPLACE(substring(INDEX2_LIST, 1, 200), ';', '<br>') INDEX2_LIST, " +
      " REPLACE(substring(KEY_LIST, 1, 200), CHAR(13), '<br>') KEY_LIST, DDQS_DOC.rowguid " +
      " from DDQS_DOC, DDQS_INDEX1 " +
      " where " + Session('SEARCH1_WhereCon') +
      " and DDQS_DOC.INDEX1_idx=DDQS_INDEX1.rowguid " +
      " order by " + Session('SEARCH1_Order'),
      new Array(
          'DOCNO', 'IDNO', 'INDEX1', 'INDEX2_LIST', 'KEY_LIST'),
      new Array(
          '文號', '統一編號', '稅目', '復查項目', '關鍵字'),
      'pg1_1_1_d.asp', false, '', '', '');
  }
%>

</body>

</html>
