<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('系統管理 - 使用者管理');
  
  if (IsNull(Rcv.Item('_enabled_only')))
    Rcv.SetItem('_enabled_only', 'Y');
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
            <p>　
            <b>使用者瀏覽</b>
            <table border="0" cellpadding="1" cellspacing="1">
              <form action="user_man.asp" method="post">
              <tr>
                <td><strong>授權角色:</strong></td>
                <td><% 
            ShowCodeSelect('S0', '_user_role_id', Rcv.Item('_user_role_id'), '', true); 
                  %></td>
              </tr>
              <tr>
                <td><strong>所屬科室單位:</strong></td>
                <td><% 
            ShowSQLSelect("select DEPTNM from DEPT_VIEW order by DEPTNM", "DEPTNM", "DEPTNM", "_dept", Rcv.Item('_dept'), '', true, "text", false);
                  %></td>
              </tr>
              <tr>
                <td><strong>使用者:</strong></td>
                <td><Input type="text" class=text name="_user_id" value="<%=Rcv.Item('_user_id')%>"></td>
              </tr>
              <tr>
                <td><strong>僅顯示有效使用者:</strong></td>
                <td><%
            ShowBoolSelect('_enabled_only', Rcv.Item('_enabled_only'), '', 'text', false);
                  %><input type="submit" class="button" value="查詢"></td>
              </tr>
              </form>
            </table>
            <p><%
            BrowseData(
                "SELECT " + 
                "  code_content as user_role_name, " + 
                "  dbo.GetSubRoles(webap_user.rowguid, webap_user.user_role_id) as user_subrole_names, " + 
                "  user_name, " + 
                "  SECTN_CHI_NM as user_dept, " + 
                "  user_idn, " + 
                "  user_id, " + 
                "  user_enabled, " + 
                "  user_last_login_ip, " + 
                "  webap_user.rowguid " + 
                "FROM webap_user " + 
                "LEFT JOIN " + 
                "  webap_code ON webap_user.user_role_id = code_id and code_kind = 'S0' " + 
                "LEFT JOIN " + 
                "  QICT105 ON QICT105.EMPL_CD = substring(webap_user.user_id, 4, 5) " + 
                "LEFT JOIN " + 
                "  QICT010 ON QICT010.DIVISION_CD = QICT105.DIVISION_CD " + 
                "    and QICT010.ORG_CD + QICT010.SECTN_CD = QICT105.ORG_SECTN " + 
                "WHERE 1=1 " + 
                (Rcv.Item('_enabled_only')!='Y'?"":
                  "  and user_enabled = 'Y' ") + 
                (IsNull(Rcv.Item('_user_id'))?"":
                  "  and (user_id like '%" + Rcv.Item('_user_id') + "%' " + 
                  "  or user_name like '%" + Rcv.Item('_user_id') + "%') ") +
                (IsNull(Rcv.Item('_user_role_id'))?"":
                  "  and (user_role_id = '" + Rcv.Item('_user_role_id') + "' " + 
                  "  or '" + Rcv.Item('_user_role_id') + "' in (select uroles_role_id from webap_userroles where uroles_user_rowguid=webap_user.rowguid)) ") +
                (IsNull(Rcv.Item('_dept'))?"":
                  " and SECTN_CHI_NM like '" + Rcv.Item('_dept') + "%' ") + 
                "order by user_dept, user_name, user_id ",
                new Array('user_role_name', 'user_subrole_names', 'user_name', 'user_dept', 'user_idn', 'user_id', 'user_enabled', 'user_last_login_ip'), 
                new Array('主要角色', '次要角色', '姓名', '單位', '員工編號', '使用者編號', '有效', '上次登入IP位址'), 
                'user_detail.asp', true, 'user_role_id='+Rcv.Item('user_role_id'));
            %></p>
      <form action="user_update.asp" method="post">
      <% ShowSQLSelect("select DEPTID, DEPTNM from DEPT_VIEW order by DEPTNM", "DEPTID", "DEPTNM", "_DDEPT", '', '', true, "text", false); %><br>
      <input type="submit" class="button" name="_action" value="批次加入使用者"><input type="submit" class="button" name="_action" value="批次移除使用者">
      </form>
          </td>
        </tr>
      </table>
      <br>
      <br>
      <input class="button" type="button" value="回選單頁" style="width:200px;" onclick="location.href='sys_menu.asp'">
    </td>
  </tr>
</table>

</body>

</html>
