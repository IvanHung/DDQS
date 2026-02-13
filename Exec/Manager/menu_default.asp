<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="_menu.asp" -->
<html>
<%
  HtmlHeader('選單');
  
  if (IsNull(Session('user_name')) ||
      IsNull(Session('login_time')) ||
      IsNull(Session('user_id')) ||
      IsNull(Session('user_rowguid')))
  {
%>
  <html>
  <script language="JavaScript">
    _top.location = "relogin.asp";
  </script>
  </html>
<%
    Response.End;
  }

%>
<base target="content">
<body style="background-image: url(./images/menuBG.JPG);">

<%
  user_role_name = GetSelectText("select code_content from webap_code where code_kind = 'S0' and code_id = '" + Session('user_role_id') + "'");
%>

<table border="0" cellpadding="0" cellspacing="0" width="150">
  <tr>
    <td colspan="2" nowrap>
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
          <td valign="center" width="100%">
            <p align="left" style="FONT-FAMILY: 細明體; color: white; FONT-SIZE: 9pt"><img src="./images/ntak.png"><br><b><%=CHDateToFullDateStr()%><br><%=user_role_name%><br><%=Session('user_name')%></b></p>
            <hr>
          </td>
        </tr>
      </table>
    </td>
  </tr>
<%
  WriteMenuTable();
%>
  <tr>
    <td align=left><img alt border="0" src="./images/MenuIcon<%=SysMenuIconClass%>b.gif"></td><td width="100%"><font size="2"><a class=menubutton href="frame.asp" target="_top" onMouseDown="BtnDown(this);" onMouseUp="BtnUp(this);" onMouseOver="BtnMouseOver(this);" onMouseOut="BtnMouseOut(this);">隱藏顯示選單</a></font></td>
  </tr>
</table>

</body>

</html>
