<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('訴願決定書-資料維護');
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

  CreateUI('pg2_1_2.asp', 'mainform', false, true,
      new Array(
        'submit', '查詢',
        "location.href='pg2_1_2_n.asp'", '新增'
      ),
      new Array(
        new Array('space', '<font color=white>查詢條件</font>'),
        new Array('sqlcombobox', '稅目:', 'INDEX1_idx', 'rw', Rcv.Item('INDEX1_idx'), 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, "onChange='mainform.submit();'"),
        new Array('sqlcombobox', '訴願項目:', '_INDEX2_idx', 'rw', Rcv.Item('_INDEX2_idx'), 'rowguid', 'INDEX2', "select * from DDQS_INDEX2 " +
            "where " + (IsNull(Rcv.Item('INDEX1_idx'))?"1=0":"INDEX1_rowguid='" + Rcv.Item('INDEX1_idx') + "'") + " order by INDEX2", true, "onChange='mainform.submit();'"),
        new Array('sqlcombobox', '關鍵字:', '_KEY', 'rw', Rcv.Item('KEYS'), 'KEYS', 'KEYS', "select KEYS from DDQS_KEYS " +
            "where " + (IsNull(Rcv.Item('_INDEX2_idx'))?"1=0":"INDEX2_rowguid='" + Rcv.Item('_INDEX2_idx') + "'") + " order by KEYS", true, "onChange='mainform.submit();'"),
        new Array('customcombobox', '為逕提訴願案件:', 'PEOPLE_SUBMIT', 'rw', '', new Array('', '全部', 'Y', '是', 'N', '否'), false, ''),
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
        '', 1,
        'sameline', 1,
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

    WhereCon += " and DOC_TYPE = '2' ";

    if (!IsNull(Rcv.Item('_INDEX2_idx')))
      WhereCon += " and INDEX2_LIST like '%" + GetSelectText("select INDEX2 from DDQS_INDEX2 where rowguid='" + Rcv.Item('_INDEX2_idx') + "'") + "%' ";

    if (!IsNull(Rcv.Item('_KEY')))
      WhereCon += " and KEY_LIST like '%" + Rcv.Item('_KEY') + "%' ";

    if (!IsNull(Rcv.Item('_SKEY')))
    {
      Rcv.SetItem('_SKEY', ReplaceStrAll(Rcv.Item('_SKEY'), ' ', '%'));
      WhereCon += " and (KEY_LIST like '%" + Rcv.Item('_SKEY') + "%' or DOC like '%" + Rcv.Item('_SKEY') + "%') ";
    }

    Session('SEARCH2_WhereCon') = WhereCon;
    Session('SEARCH2_Order') = " SEND_DATE desc ";
  }

  if (!IsNull(Session('SEARCH2_WhereCon')))
  {
    BrowseData("select " +
      " SEND_DATE, DOCNO, IDNO, DDQS_INDEX1.INDEX1, REPLACE(substring(INDEX2_LIST, 1, 200), ';', '<br>') INDEX2_LIST, " +
      " REPLACE(substring(KEY_LIST, 1, 200), CHAR(13), '<br>') KEY_LIST, case PEOPLE_SUBMIT when 'Y' then '是' else '否' end as PEOPLE_SUBMIT, " +
      " DDQS_DOC.rowguid " +
      " from DDQS_DOC " +
      " left join DDQS_INDEX1 on DDQS_DOC.INDEX1_idx=DDQS_INDEX1.rowguid " +
      " where " + Session('SEARCH2_WhereCon') +
      " order by " + Session('SEARCH2_Order'),
      new Array(
          'SEND_DATE', 'DOCNO', 'IDNO', 'INDEX1', 'INDEX2_LIST', 'KEY_LIST', 'PEOPLE_SUBMIT'),
      new Array(
          '發文日期', '文號', '統一編號', '稅目', '訴願項目', '關鍵字', '為逕提訴願案件'),
      'pg2_1_2_d.asp', false, '', '', '');
  }
%>

</body>

</html>
