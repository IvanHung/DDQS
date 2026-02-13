<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
try
{
  HasFile = FileExists(ToRealFilePath("/") + "\\FileStore\\" + Request.QueryString('i') + "\\" + Request.QueryString('n'));
}
catch (e)
{
  HasFile = false;
}

if (HasFile)
{
    Response.Redirect("/FileStore/" + Request.QueryString('i') + "/" + Request.QueryString('n'));
}
%>