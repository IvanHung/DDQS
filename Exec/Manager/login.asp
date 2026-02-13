<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  Session.Abandon;
%>
<html>
<%
  HtmlHeader('登入');
  SetPagesHome();
%>
<body>

<table border="0" class=pagetable cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  //ContentHeader();
  %>
  <tr>
    <td align=center valign=center nowrap>
      <br>
      <table border=3 cellpadding=2 cellspacing=5 bgcolor=white borderColor=#202020 style="margin-bottom: 1px; height=400px; width=384px;" background="./images/loginBG.jpg">
        <tr>
          <td align=center valign=center nowrap>
            <form action="do_login.asp" method="post">
              <table border=0 width="100%" height="100%">
                <tr>
                  <td align="middle" align=center valign=center nowrap>
                    <br><br><br><font size=3><b><%=SysTitle%></b></font><br><br><font style="font: 9pt 細明體;" color=red>如果您是[一般使用者], 而不是[系統權限管理員], <br>請您[使用Windows認證機制自動登入].</font><br>
<input class="button" style="width:250px;height:50px;background-color:red;border: 1px outset red;" type="button" value="使用Windows認證機制自動登入" onClick="location.href='<%=SysWindowsUserLoginURL%>';">                    <p><font style="font: 9pt 細明體;">請您輸入您位於本管理系統<font color=red>(不是Windows認證機制)</font>的<br>使用者編號與密碼, 以登入本系統.</font><br>
                    <table border="0" cellpadding="1" cellspacing="1" height=50>
                      <tr>
                        <td>
                          <p align="right">使用者編號</p>
                        </td>
                        <td height="40" nowrap style="HEIGHT: 10px"><input class="text" id="login_text" maxlength="10" name="user_id" value="<%=Request.Cookies(SysID + '_webap_userid')%>" onblur="this.value=this.value.toUpperCase();" size="10"></td>
                      </tr>
                      <tr>
                        <td>
                          <p align="right">使用者密碼</p>
                        </td>
                        <td height="40" style="HEIGHT: 40px"><input class="text" id="login_password" maxlength="10" name="user_password" size="10" type="password"></td>
                      </tr>
                    </table>
                    <p><input name="_action" size="10" type="hidden" value="login"><input class="button" style="width:200px; height:30px;" type="submit" value="登入"></p>
                  </td>
                </tr>
              </table>
            </form>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align=center valign=center nowrap>
      <table>
        <tr>
          <td><font color="red">
            <ul>
              <li type="square">注意: 請於離開前務必執行[登出]功能，以避免其他不明的使用者，使用該電腦進入本系統</li>
              <li type="square">建議使用瀏覽器: Microsoft Internet Explorer 6.0 或是以上版本</li>
              <li type="square">本系統目前版本: <%=SysVersion%></li>
              <li type="square">建議使用螢幕解析度: 1024x768</li>
            </ul>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>

</html>
