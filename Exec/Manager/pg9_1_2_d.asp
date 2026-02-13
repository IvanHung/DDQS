<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('資料維護-項目維護-明細');

  var Sav = new QrySave();

  if (Rcv.Item('rowguid') != '')
  {
    Sav.Exec("select * from DDQS_INDEX2 where rowguid = '" + Rcv.Item('rowguid') + "'");
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
    CreateUI('pg9_1_2_r.asp', 'mainform', true, false,
        new Array(
            'submit', '修改',
            'submit', '刪除',
            "location.href='pg9_1_2.asp'", '回瀏覽頁'
        ),
        new Array(
          // 案件內容
          new Array('sqlcombobox', '稅目:', 'INDEX1_rowguid', 'r', '', 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, ''),
          new Array('text', '項目:', 'INDEX2', 'rw', '', 50, 50, ''),
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
  else
  {
    CreateUI('pg9_1_2_r.asp', 'mainform', false, false,
        new Array(
            'submit', '新增',
            "location.href='pg9_1_2.asp'", '回瀏覽頁'
        ),
        new Array(
          // 案件內容
          new Array('sqlcombobox', '稅目:', 'INDEX1_rowguid', 'rw', Session('Search_INDEX1'), 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, ''),
          new Array('text', '項目:', 'INDEX2', 'rw', '', 50, 50, '')
        )
      );
  }
%>
    </td>
  </tr>
</table>

</body>

</html>
