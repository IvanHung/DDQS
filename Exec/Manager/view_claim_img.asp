<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  HtmlHeader('電子訂貨 - 顯示樣品展示圖');

  var ImgExt = ExtractFileExtName(Rcv.Item('claim_picture'));
  if (
    (ImgExt != '.jpg') &&
    (ImgExt != '.jpeg') &&
    (ImgExt != '.gif')
     )
    Rcv.SetItem('claim_picture', Rcv.Item('claim_picture') + '.jpg');
%>
<html>
<body>
<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%">
  <tr id=_ContentHeader>
    <td height=60>
      <table border=0 cellpadding=2 cellspacing=0 align=center bgcolor=#FFFFFF width="100%" height="100%">
        <tr>
          <td align=center valign=center><font style="font-family: 新細明體; font-size: 11pt;"><b>電子訂貨 - 顯示樣品展示圖</b></font></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align=center>
      <b>供應人:<%=Rcv.Item('su_no')%><br>
      承銷人:<%=Rcv.Item('bu_no')%><br>
      品名:<%=Rcv.Item('pr_name')%><br>
      圖檔名稱:<%=Rcv.Item('claim_picture')%><br></b>
      <img border=0 src="./ClaimPic/<%=Rcv.Item('claim_picture')%>"><br>
      如果您沒有看到圖檔, 請通知本系統管理員.
    </td>
  </tr>
  <tr>
    <td align=center>
      <input class="button" type="button" value="關閉" onClick="window.close();">
    </td>
  </tr>
</table>

</body>

</html>

