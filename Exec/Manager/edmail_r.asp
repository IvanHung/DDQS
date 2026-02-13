<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  HtmlHeader('編輯新郵件-結果');

  SendEMail(Rcv.Item('TO_ADDR'), Rcv.Item('SUBJECT'), Rcv.Item('BODY'))

  ShowMessage('送信完成.',
      new Array('繼續編輯新郵件', "location.href='edmail.asp'"));
%>
