<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('關鍵字維護-明細');

  var Sav = new QrySave();

  if (Rcv.Item('rowguid') != '')
  {
    Sav.Exec("select * from DDQS_KEYS where rowguid = '" + Rcv.Item('rowguid') + "'");
    SubTitle = '明細';
  }
  else
  {
    SubTitle = '新增';
  }
%>
<body>

<table border="0" class=pagetable cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td nowrap align="middle" valign="center">
<%
  if (Rcv.Item('rowguid') != '')
  {
    CreateUI('pg9_1_3_r.asp', 'mainform', true, false,
        new Array(
            'submit', '修改',
            'submit', '刪除',
            "location.href='pg9_1_3.asp'", '回瀏覽頁'
        ),
        new Array(
          // 案件內容
          new Array('sqlcombobox', '稅目:', '_INDEX1_rowguid', 'r', GetSelectText("select INDEX1_rowguid from DDQS_INDEX2 where rowguid='" + Sav.Item('INDEX2_rowguid') + "'"), 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, ''),
          new Array('sqlcombobox', '項目:', 'INDEX2_rowguid', 'r', '', 'rowguid', 'INDEX2', "select * from DDQS_INDEX2 order by INDEX2", true, ''),
          new Array('text', '關鍵字:', 'KEYS', 'rw', '', 50, 50, ''),
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
  else
  {
    if (!IsNull(Rcv.Item('_INDEX1_rowguid')))
      Session('Search_INDEX1') = Rcv.Item('_INDEX1_rowguid');

    CreateUI('pg9_1_3_r.asp', 'mainform', false, false,
        new Array(
            'submit', '新增',
            "location.href='pg9_1_3.asp'", '回瀏覽頁'
        ),
        new Array(
          // 案件內容
          new Array('sqlcombobox', '稅目:', '_INDEX1_rowguid', 'rw', Session('Search_INDEX1'), 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, "onChange='mainform.action=\"pg9_1_3_d.asp\"; mainform.submit();'"),
          new Array('sqlcombobox', '項目:', 'INDEX2_rowguid', 'rw', Session('Search_INDEX2'), 'rowguid', 'INDEX2', "select * from DDQS_INDEX2 " +
              "where " + (IsNull(Session('Search_INDEX1'))?"1=0":"INDEX1_rowguid='" + Session('Search_INDEX1') + "'") + " order by INDEX2", true, ''),
          new Array('text', '關鍵字:', 'KEYS', 'rw', '', 50, 50, '')
        )
      );
  }
%>
    </td>
  </tr>
</table>

</body>

</html>
