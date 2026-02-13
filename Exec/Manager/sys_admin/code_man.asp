<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  if (Rcv.Item('code_kind') == '')
    Rcv.SetItem('code_kind', '0');
    
  if (Rcv.Item('code_kind') == '')
    SelectKind = '';
  else
    SelectKind = ' - ' + GetCodeContent('0', Rcv.Item('code_kind'));
%>
<html>
<%
  HtmlHeader('系統管理 - 代碼管理' + SelectKind);
%>
<script language="javascript">
<!--
function dropdown_action(s)
{  
  var d = 'code_man.asp?code_kind=' + s.options[s.selectedIndex].value;
  if (s.selectedIndex >= 0) 
    location.href = d;
  else
    s.selectedIndex=0;
  return false;
}
//-->
</script>
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
            <p><strong>代碼瀏覽<%=SelectKind%></strong></p>
            <table border="0" cellpadding="1" cellspacing="1">
              <tr>
                <td><strong>代碼類別:</strong></td>
                <td><% 
            ShowCodeSelect('0', '_code_kind', Rcv.Item('code_kind'), 'onChange="dropdown_action(this);"'); 
                  %></td>
              </tr>
            </table>
            <p><% BrowseData("select code_id, code_content, code_descript, code_order, rowguid from webap_code where code_kind = '" + Rcv.Item('code_kind') + "' " + 
                      " order by code_order, len(code_id), code_id", 
                      new Array('code_id', 'code_content', 'code_descript', 'code_order'), 
                      new Array('代碼編號', '代碼內容', '代碼說明', '順序'), 
                      'code_detail.asp', true, 'code_kind='+Rcv.Item('code_kind')); %></p>
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
