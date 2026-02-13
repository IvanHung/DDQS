<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  var Sav = new QrySave();
  
  if (Rcv.Item('rowguid') != '')
  {
    Sav.Exec("select * from webap_code where rowguid = '" + Rcv.Item('rowguid') + "'");
    SubTitle = '明細';
  }
  else
  {
    Sav.SetItem('code_kind', Rcv.Item('code_kind'));
    SubTitle = '新增';
  }
%>
<html>
<%
  HtmlHeader('系統管理 - 代碼管理 - ' + SubTitle);
%>
<body>

<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td align="middle" nowrap valign="center">
      <br>
      <table border=3 cellpadding=2 cellspacing=5 width="80%" height="80%" bgcolor=white borderColor=#8080FF style="margin-bottom: 1px;" >
        <tr>
          <td align=center valign=center nowrap>
<%
  if (Sav.Item('code_kind') == '0')
  {
    CreateUI('code_detail_r.asp', '', true, false, 
        new Array(
          'submit', '修改',
//          'submit', '新增',
          'submit', '刪除',
          "location.href='code_man.asp?code_kind=" + Sav.Item('code_id') + "'", '瀏覽該類代碼',
          "location.href='code_man.asp?code_kind=" + Sav.Item('code_kind') + "'", '回瀏覽頁'
        ), 
        new Array(
          new Array('code', '代碼類別:', 'code_kind', 'w', '', '0', true, ''),
          new Array('text', '代碼編號:', 'code_id', 'w', '', 12, 12, ''),
          new Array('text', '代碼內容:', 'code_content', 'w', '', 60, 120, ''),
          new Array('text', '代碼說明:', 'code_descript', 'rw', '', 60, 60, ''),
          new Array('text', '順序:', 'code_order', 'rw', '', 3, 3, ''),
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
  else if (Rcv.Item('rowguid') != '')
  {
    CreateUI('code_detail_r.asp', '', true, false, 
        new Array(
          'submit', '修改',
//          'submit', '新增',
          'submit', '刪除',
          "location.href='code_man.asp?code_kind=" + Sav.Item('code_kind') + "'", '回瀏覽頁'
        ), 
        new Array(
          new Array('code', '代碼類別:', 'code_kind', 'w', '', '0', true, ''),
          new Array('text', '代碼編號:', 'code_id', 'w', '', 12, 12, ''),
          new Array('text', '代碼內容:', 'code_content', 'w', '', 60, 120, ''),
          new Array('text', '代碼說明:', 'code_descript', 'rw', '', 60, 60, ''),
          new Array('text', '順序:', 'code_order', 'rw', '', 3, 3, ''),
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
  else
  {
    CreateUI('code_detail_r.asp', '', true, false, 
        new Array(
          'submit', '新增',
          "location.href='code_man.asp?code_kind=" + Sav.Item('code_kind') + "'", '回瀏覽頁'
        ), 
        new Array(
          new Array('code', '代碼類別:', 'code_kind', 'w', '', '0', true, ''),
          new Array('text', '代碼編號:', 'code_id', 'w', '', 12, 12, ''),
          new Array('text', '代碼內容:', 'code_content', 'w', '', 60, 120, ''),
          new Array('text', '代碼說明:', 'code_descript', 'rw', '', 60, 60, ''),
          new Array('text', '順序:', 'code_order', 'rw', '', 3, 3, ''),
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
%>
          </tr>
        </td>
      </table>
      <br>
      <input class="button" type="button" value="回選單頁" style="width:200px;" onclick="location.href='sys_menu.asp'">
    </td>
  </tr>
</table>

</body>

</html>
<%
  Sav = null;
%>