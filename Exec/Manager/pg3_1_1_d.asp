<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('行政訴訟裁判書-資料查詢-明細');

  var Sav = new QrySave();

  if (Rcv.Item('rowguid') != '')
  {
    Sav.Exec("select * from DDQS_DOC where rowguid = '" + Rcv.Item('rowguid') + "'");
    SubTitle = '明細';

    while (!Session('SEARCH3_RowGuids').eof)
    {
      if (Session('SEARCH3_RowGuids')('rowguid') == Rcv.Item('rowguid'))
        break;
      Session('SEARCH3_RowGuids').moveNext;
    }
  }
  else
  {
    if (Rcv.Item('Move') == 'Next' && !Session('SEARCH3_RowGuids').eof)
      Session('SEARCH3_RowGuids').moveNext;

    if (Rcv.Item('Move') == 'Prior' && !Session('SEARCH3_RowGuids').bof)
      Session('SEARCH3_RowGuids').move(-1);

    if (IsNull(Session('SEARCH3_RowGuids')('rowguid')))
      if (Rcv.Item('Move') == 'Next')
        Session('SEARCH3_RowGuids').moveLast;
      else if (Rcv.Item('Move') == 'Prior')
        Session('SEARCH3_RowGuids').moveFirst;

    Rcv.SetItem('rowguid', ''+Session('SEARCH3_RowGuids')('rowguid'));

    Sav.Exec("select * from DDQS_DOC where rowguid = '" + Rcv.Item('rowguid') + "'");
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
    LogREAD(Sav.Item('DOCNO'), 3);

    CreateUI('', 'mainform', true, false,
        new Array(
            "location.href='pg3_1_1.asp'", '回瀏覽頁',
            "location.href='pg3_1_1_p.asp?rowguid=" + Sav.Item('rowguid') + "'", '列印',
            "location.href='pg3_1_1_d.asp?Move=Prior'", '上一筆',
            "location.href='pg3_1_1_d.asp?Move=Next'", '下一筆'
        ),
        new Array(
          // 案件內容
          new Array('space', '<font color=white>行政訴訟裁判書內容</font>'),
          new Array('text', '文號:', 'DOCNO', 'r', '', 20, 20, ''),
          new Array('text', '統一編號:', 'IDNO', 'r', '', 10, 10, ''),
          new Array('chdate', '發文日期:', 'SEND_DATE', 'r', '', ''),
          new Array('sqlcombobox', '稅目:', 'INDEX1_idx', 'r', '', 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, ''),
          new Array('textarea', '行政訴訟項目:', 'INDEX2_LIST', 'r', '', 5, 80, 2000, ''),
          new Array('textarea', '關鍵字:', 'KEY_LIST', 'r', '', 5, 80, 2000, ''),
          new Array('spacehint', '<a href="download_doc.asp?i=' + Sav.Item('rowguid') + '&n=' + Sav.Item('FILE_NAME') + '">下載 [檔案名稱 ' + Sav.Item('FILE_NAME') + ']</a>'),
          new Array('textarea', '內容:', 'DOC', 'r', '', 5, 80, 2000, ''),
          new Array('spacehint', '<font color=black>查詢資料共 ' + Session('SEARCH3_RowGuids').RecordCount + ' 筆, 目前在 ' +
              Session('SEARCH3_RowGuids').AbsolutePosition + ' 筆' +
              (Session('SEARCH3_RowGuids').AbsolutePosition<=1?' [第一筆]':'') +
              (Session('SEARCH3_RowGuids').AbsolutePosition>=Session('SEARCH3_RowGuids').RecordCount?' [最後一筆]':'') + '</font>'),
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
  else
  {
%>資料不存在
<%
  }
%>
    </td>
  </tr>
</table>

</body>

</html>
