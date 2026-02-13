<!--#include file="_define.asp" -->
<%
  Response.Expires = 0;
  Response.ExpiresAbsolute;
  
  Response.Write("<!--" + SysTitle + "\n");
  Response.Write("* HTTP Info *******************************************************\n");
  Response.Write(Request.ServerVariables("ALL_HTTP"));
  Response.Write("* Extended Info ***************************************************\n");
  Response.Write("LoginUserName=" + Session("user_name") + "\n");
  Response.Write("LoginTime=" + Session("login_time") + "\n");
  Response.Write("LoginIP=" + Request.ServerVariables("REMOTE_ADDR") + "\n");
  Response.Write("URL=" + Request.ServerVariables("URL") + "\n");
  Response.Write("CurrentTime=" + ACDateToStr() + " " + ACTimeToStr() + "\n");
  Response.Write("* Info End ********************************************************\n");
  Response.Write("-->\n");
%>
<!--#include file="_chkfunc.asp" -->
<!--#include file="_common.asp" -->
<!--#include file="_dbctrl.asp" -->
<!--#include file="_htmlmod.asp" -->
<!--#include file="_rcvdata.asp" -->
<!--#include file="_filectrl.asp" -->
<!--#include file="_xmlctrl.asp" -->
<!--#include file="_menu.asp" -->
<!--#include file="_ap_functions.asp" -->
