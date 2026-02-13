<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  if (Rcv.Item('_action') == '修改密碼')
  {
    var Qry = SQLExecute("select * from webap_user where rowguid='" + Rcv.Item('rowguid') + "'");
    
    if (Qry.Eof)
      ErrorMsg('使用者不存在.');
    if ((''+Qry('user_password')).toUpperCase() != (''+Rcv.Item('_old_password')).toUpperCase())
      ErrorMsg('舊密碼錯誤, 請重新輸入.');
    if ((''+Rcv.Item('_new_password')).toUpperCase() != (''+Rcv.Item('_new_password2')).toUpperCase())
      ErrorMsg('新密碼確認錯誤, 請重新輸入.');

    SQLExecute("update webap_user set user_password = '" + 
        (''+Rcv.Item('_new_password')).toUpperCase() + "' where rowguid = '" + Rcv.Item('rowguid') + "'");
    ErrorMsg('密碼更新成功.');
  }

  var Sav = new QrySave();
  
  Sav.Exec("select * from webap_user where rowguid = '" + Session('user_rowguid') + "'");
%>
<html>
<%
  HtmlHeader('更改密碼');
%>
<body>

<table border="0" class=pagetable cellpadding="1" cellspacing="1" height="100%" width="100%">
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
  CreateUI('user_password.asp', '', true, false, 
      new Array(
        'submit', '修改密碼'
      ), 
      new Array(
        new Array('space', '<font color=white>使用者密碼資料</font>'),
        new Array('passwd', '舊密碼:', '_old_password', 'w', '', 10, 10, ''),
        new Array('passwd', '新密碼:', '_new_password', 'w', '', 10, 10, ''),
        new Array('passwd', '新密碼(確認):', '_new_password2', 'w', '', 10, 10, ''),
        new Array('space', '<font color=white>使用者基本資料</font>'),
        new Array('text', '使用者編號:', 'user_id', 'r', '', 10, 10, ''),
        new Array('text', '使用者名稱:', 'user_name', 'r', '', 12, 12, ''),
        new Array('text', '使用者編號:', 'user_idn', 'r', '', 10, 10, ''),
        new Array('text', '上次登入IP位址:', 'user_last_login_ip', 'r', '', 15, 15, ''),
        new Array('text', '上次登入成功時間:', 'user_last_login_success_time', 'r', '', 20, 20, ''),
        new Array('text', '上次登入失敗時間:', 'user_last_login_fail_time', 'r', '', 20, 20, ''),
        new Array('savedcode', '權限編號:', 'user_role_id', 'r', '', 'S0', true, ''),
        new Array('hidden', 'rowguid', '', '')
      )
    );
%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>

</html>
<%
  Sav = null;
%>