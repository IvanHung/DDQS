<%
function SimpleShowMessage(Title, Msg)
{
%>
<html>
<head>
  <meta HTTP-EQUIV=Content-Language Content=zh-tw>
  <meta HTTP-EQUIV=Content-Type Content='text/html; charset=big5'>
  <link HREF=/member/default.css REL=stylesheet TYPE=text/css>
<title>訊息 - <%=Title%></title>
</head>
<body>

<!-- CustomMessage() Begin -->

<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%">
  
<!-- ContentHeader() Begin -->
  <tr id=_ContentHeader>
    <td height=60>
      <table border=0 cellpadding=2 cellspacing=0 align=center bgcolor=#FFFFFF width="100%" height="100%">
        <tr>
          <td align=center valign=center><font style="font-family: 新細明體; font-size: 11pt;"><img src="/member/images/banner.jpg"><br><b>- <%=Title%> -</b></b></font>
</td>
        </tr>
      </table>
    </td>
  </tr>
<!-- ContentHeader() End -->

  <tr>
    <td align="middle" nowrap valign="center">
      <p>
      <table border="0" cellpadding="1" cellspacing="1" height="80%" width="80%">
      <tr>
        <td align="center" valign="center"><%=Msg%><br><input class="button" type="button" value="回上一頁" onClick="history.go(-1)" id="btnBack" name="btnBack">
<script language="javascript">
<!--
   document.all.btnBack.focus();
-->
</script>

</td></tr></table></p></p></td></tr></table></p>

<!-- CustomMessage() End -->

</body>
</html>
<%

  Response.End;
}
%>