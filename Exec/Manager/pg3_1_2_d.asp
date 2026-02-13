<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('行政訴訟裁判書-資料維護-明細');

  var Sav = new QrySave();

  if (Rcv.Item('rowguid') != '')
  {
    Sav.Exec("select * from DDQS_DOC where rowguid = '" + Rcv.Item('rowguid') + "'");
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
    LogREAD(Sav.Item('DOCNO'), 3);

    CreateUI('pg3_1_2_r.asp', 'mainform', true, false,
        new Array(
            "location.href='pg3_1_1_p.asp?rowguid=" + Sav.Item('rowguid') + "'", '列印',
            "location.href='pg3_1_2_n.asp'", '新增行政訴訟裁判書',
            "submit", '修改',
            "if (window.confirm('您確認要刪除此筆資料嗎?')) location.href='pg3_1_2_r.asp?_action=刪除&rowguid=" + Sav.Item('rowguid') + "';", '刪除',
            "location.href='pg3_1_2.asp'", '回瀏覽頁'
        ),
        new Array(
          // 案件內容
          new Array('space', '<font color=white>行政訴訟裁判書內容</font>'),
          new Array('text', '文號:', 'DOCNO', 'rw', '', 20, 20, ''),
          new Array('text', '統一編號:', 'IDNO', 'rw', '', 10, 10, ''),
          new Array('chdate', '發文日期:', 'SEND_DATE', 'rw', '', ''),
          new Array('sqlcombobox', '稅目:', 'INDEX1_idx', 'rw', '', 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, ''),
          new Array('textarea', '行政訴訟項目:', 'INDEX2_LIST', 'rw', '', 5, 80, 2000, ''),
          new Array('textarea', '關鍵字:', 'KEY_LIST', 'rw', '', 5, 80, 2000, ''),
          new Array('spacehint', '<a href="download_doc.asp?i=' + Sav.Item('rowguid') + '&n=' + Sav.Item('FILE_NAME') + '">下載 [檔案名稱 ' + Sav.Item('FILE_NAME') + ']</a>'),
          new Array('textarea', '內容:', 'DOC', 'rw', '', 30, 80, 2000, ''),
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
  else
  {
    if (Rcv.Item('file_name') != '')
      Session('FILE_NAME2') = Rcv.Item('file_name');
    Rcv.SetItem('FILE_NAME', Session('FILE_NAME2'));

    if (Rcv.Item('_LAST_INDEX1_idx') != Rcv.Item('INDEX1_idx'))
    {
      Rcv.SetItem('INDEX2_LIST', "");
      Rcv.SetItem('_INDEX2_idx', "");
      Rcv.SetItem('KEY_LIST', "");
    }
    else
    {
      if (!IsNull(Rcv.Item('_INDEX2_idx')))
      {
        Rcv.SetItem('_INDEX2_idx', TrimCh(Rcv.Item('_INDEX2_idx')));

        if (Rcv.Item('_INDEX2_idx') == '[CLEAR]')
        {
          Rcv.SetItem('INDEX2_LIST', "");
          Rcv.SetItem('_INDEX2_idx', "");
        }
        else
        {
          var INDEX2_TEXT = GetSelectText("select INDEX2 from DDQS_INDEX2 where rowguid='" + Rcv.Item('_INDEX2_idx') + "'");

          INDEX2_TEXT = TrimCh(INDEX2_TEXT);

          if (!IsNull(INDEX2_TEXT))
          {
            if (!IsNull(Rcv.Item('INDEX2_LIST')))
            {
              if (!FindInStr(TrimCh(Rcv.Item('INDEX2_LIST')), INDEX2_TEXT))
                Rcv.SetItem('INDEX2_LIST', Rcv.Item('INDEX2_LIST') + ';' + INDEX2_TEXT);
            }
            else
              Rcv.SetItem('INDEX2_LIST', INDEX2_TEXT);
          }
        }
      }

      if (Rcv.Item('_KEYS') == '[清除關鍵字]')
      {
        Rcv.SetItem('KEY_LIST', "");
      }
      else
      {
        var KEY = Rcv.Item('_KEYS');

        if (IsNull(KEY))
          KEY = Rcv.Item('_CUSTOM_KEY');

        if (!IsNull(KEY))
        {
          if (!IsNull(Rcv.Item('KEY_LIST')))
          {
            Rcv.SetItem('KEY_LIST', TrimCh(Rcv.Item('KEY_LIST')));

            if (!FindInStr(Rcv.Item('KEY_LIST'), KEY))
              Rcv.SetItem('KEY_LIST', Rcv.Item('KEY_LIST') + ';' + KEY);
          }
          else
            Rcv.SetItem('KEY_LIST', KEY);
        }
      }

      Rcv.SetItem('_CUSTOM_KEY', '');
    }

    CreateUI('pg3_1_2_r.asp', 'mainform', false, true,
        new Array(
            'submit', '新增',
            "location.href='pg3_1_2.asp'", '回瀏覽頁'
        ),
        new Array(
          // 案件內容
          new Array('space', '<font color=white>行政訴訟裁判書內容</font>'),
          new Array('text', '文號:', 'DOCNO', 'rw', '', 20, 20, ''),
          new Array('text', '統一編號:', 'IDNO', 'rw', '', 10, 10, ''),
          new Array('chdate', '發文日期:', 'SEND_DATE', 'rw', '', ''),
          new Array('sqlcombobox', '稅目:', 'INDEX1_idx', 'rw', '', 'rowguid', 'INDEX1', "select * from DDQS_INDEX1 order by INDEX1", true, "onChange='mainform.action=\"pg3_1_2_d.asp\"; mainform.submit();'"),
          new Array('sqlcombobox', '加入行政訴訟項目:', '_INDEX2_idx', 'rw', '', 'rowguid', 'INDEX2', "select '[清除行政訴訟項目]' as INDEX2, '[CLEAR]' as rowguid union select INDEX2, cast(rowguid as varchar(40)) as rowguid from DDQS_INDEX2 " +
              "where " + (IsNull(Rcv.Item('INDEX1_idx'))?"1=0":"INDEX1_rowguid='" + Rcv.Item('INDEX1_idx') + "'") + " order by INDEX2", true, "onChange='mainform.action=\"pg3_1_2_d.asp\"; mainform.submit();'"),
          new Array('textarea', '行政訴訟項目:', 'INDEX2_LIST', 'r', '', 5, 80, 2000, ''),
          new Array('sqlcombobox', '加入關鍵字:', '_KEYS', 'rw', '-', 'KEYS', 'KEYS', "select '[清除關鍵字]' as KEYS union select KEYS from DDQS_KEYS " +
              "where " + (IsNull(Rcv.Item('_INDEX2_idx'))?"1=0":"INDEX2_rowguid='" + Rcv.Item('_INDEX2_idx') + "'") + " order by KEYS", true, "onChange='mainform.action=\"pg3_1_2_d.asp\"; mainform.submit();'"),
          new Array('text', '加入自訂關鍵字:', '_CUSTOM_KEY', 'rw', '', 40, 40, "><input type=\"button\" class=\"button\" value=\"加入\" onclick='mainform.action=\"pg3_1_2_d.asp\"; mainform.submit();' "),
          new Array('textarea', '關鍵字:', 'KEY_LIST', 'r', '', 5, 80, 2000, ''),
          new Array('bool', '為逕提行政訴訟案件:', 'PEOPLE_SUBMIT', 'rw', '', ''),
          new Array('text', '檔案名稱:', 'FILE_NAME', 'r', '', 50, 50, ''),
          new Array('textarea', '內容:', 'DOC', 'rw', '', 30, 80, 2000, ''),
          new Array('hidden', '_LAST_INDEX1_idx', Rcv.Item('INDEX1_idx'), ''),
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
%>
    </td>
  </tr>
</table>

</body>

</html>
