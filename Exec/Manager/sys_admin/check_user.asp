<%
  if (!DebugMode)
    if (Session('root_menu') == null)
      Response.Redirect("relogin.asp");
%>
