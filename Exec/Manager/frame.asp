<%@ Language=JavaScript %>
<!--#include file="_lib.asp" -->
<html>

<%
  HtmlHeader('');
%>
<script language="javascript">
<!--
  if (top.location.href != self.location.href)
    top.location.href = self.location.href;
//-->
</script>
<%
  if (Session('user_id') == null)
    Response.Redirect('logout.asp');

  var Qry = SQLExecute("select code_id from webap_code where code_kind = '0' and code_id <> '0' order by code_id");
  while (!Qry.eof)
  {
    DownloadSQLCode(Qry('code_id'), 'code_id', 'code_content', "select code_id, code_content from webap_code where code_kind='" + Qry('code_id') + "' order by code_order, code_id");
    Qry.moveNext;
  }
  Qry.Close();
  Qry = null;
  
  if (Rcv.Item('show_left_menu') == 'true')
  {
%>
<frameset cols="155,*">
  <frame name="menu" scrolling="auto" src="menu_default.asp?reload" target="content">
<%
  }
  else
  {
%>
<frameset cols="*">
<%
  }
%>
  <frame name="content" scrolling="auto" src="welcome.asp?reload" target="_self">
  <noframes>
  <body>

  <p align="center">您的網頁瀏覽器並未支援Frame功能.</p>
  <p align="center">請更新版本或下載使用Internet Explorer 3.0以上版本.</p>

  </body>
  </noframes>
</frameset>

</html>
