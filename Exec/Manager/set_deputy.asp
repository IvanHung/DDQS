<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<html>
<%
  if (Session('user_id') == null)
    Response.Redirect("relogin.asp");
    
  HtmlHeader('執行代理');
  SetPagesHome();
%>
<body>

<table border="0" class=pagetable cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td nowrap align="middle" valign="center">
<%
  if (Session('is_deputy') == null)
  {
    CreateUI('do_login.asp', 'mainform', false, false, 
        new Array(
          'submit', '開始代理',
          "location.href='welcome.asp'", '取消代理'
        ), 
        new Array(
          // 案件內容
          new Array('space', '<font color=white>執行代理</font>'),
          new Array('sqlcombobox', '被代理人:', '_DEPUTY_ID', 'w', '', 'user_id', 'user_name', 
              "SELECT " + 
              "  user_id, " + 
              "  user_id + ' ' + SECTN_CHI_NM + ' ' + user_name as user_name " + 
              "FROM webap_user   " + 
              "LEFT JOIN   " + 
              "  webap_code ON webap_user.user_role_id = code_id and code_kind = 'S0'   " + 
              "LEFT JOIN   " + 
              "  QICT105 ON QICT105.EMPL_CD = substring(webap_user.user_id, 4, 5)   " + 
              "LEFT JOIN   " + 
              "  QICT010 ON QICT010.DIVISION_CD = QICT105.DIVISION_CD   " + 
              "    and QICT010.ORG_CD + QICT010.SECTN_CD = QICT105.ORG_SECTN " + 
              "WHERE QICT105.ORG_SECTN = '" + Session('user_unit') + "' " + 
              "AND user_id <> '" + Session('user_id') + "' " + 
              "ORDER BY SECTN_CHI_NM, user_name", false, ''),
          new Array('hidden', '_CUR_USER_ID', Session('user_id'), ''),
          new Array('hidden', '_CUR_USER', 
              Session('user_id') + ' ' + Session('user_name'), '')
        )
      );
  }
  else
  {
%>
    <font style="font: 12pt 細明體;" color=red><b>您正在執行代理中, 不可再代理其他人.</b></font>
<%
    CreateUI('do_login.asp', 'mainform', false, false, 
        new Array(
          "location.href='welcome.asp'", '回首頁',
          "location.href='logout.asp'", '取消代理/登出'
        ), 
        new Array(
          // 案件內容
          new Array('space', '<font color=white>執行代理</font>'),
          new Array('text', '被代理人:', '', 'r', Session('user_id') + ' ' + Session('user_name'), 80, 80, '')
        )
      );
  }
%>
    </td>
  </tr>
</table>

</body>

</html>
