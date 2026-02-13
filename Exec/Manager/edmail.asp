<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  HtmlHeader('編輯新郵件');
  SetPagesHome();
%>
<html>
<body>

<table border="0" class=pagetable cellpadding="1" cellspacing="1" height="100%" width="100%">
  <tr>
    <td nowrap align="middle" valign="center">
<%
  CreateUI('edmail_r.asp', 'mainform', false, false, 
      new Array(
        'submit', '傳送'
      ), 
      new Array(
        new Array('space', '<font color=white>郵件內容</font>'),
        new Array('text', '收件者:', 'TO_ADDR', 'w', '', 60, 60, ''),
        new Array('text', '主旨:', 'SUBJECT', 'rw', '', 80, 80, ''),
        new Array('textarea', '內文:', 'BODY', 'rw', '', 10, 80, 2000, '')
      )
    );
%>
    </td>
  </tr>
</table>

</body>

</html>
