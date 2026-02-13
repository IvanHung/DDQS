<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  if (Rcv.Item('_action') == '儲存目前的角色設定')
  {
    var RoleIDs = new Array();
    var QryCode = SQLExecute("select code_id from webap_code where code_kind='S0' and code_id <> '0' order by len(code_id), code_id");
    while (!QryCode.Eof)
    {
      RoleIDs[RoleIDs.length] = ''+QryCode('code_id');
      QryCode.moveNext;
    }
    QryCode.Close;
    QryCode = null;
    
    for (var j=0; j<RoleIDs.length; j++)
    {
      var InstArray = Rcv.Item('selectrowguid' + RoleIDs[j]).split(', ');

      SQLExecute("delete from webap_role where role_id='" + RoleIDs[j] + "'");

      for (var i=0; i<InstArray.length; i++)
        SQLExecute("insert into webap_role (role_id, role_page_filename) values('" + RoleIDs[j] + "', '" + InstArray[i] + "')");

      InstArray = null;
    }
      
    RoleIDs = null;
  }
%>
<html>
<%
  HtmlHeader('系統管理 - 角色管理');
%>
<script language="javascript">
<!--
function dropdown_action(s)
{  
  var d = 'role_man.asp?role_id=' + s.options[s.selectedIndex].value;
  if (s.selectedIndex >= 0) 
    location.href = d;
  else
    s.selectedIndex=0;
  return false;
}
//-->
</script>
<body>

<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td align="middle" nowrap valign="center">
      <br>
      <table border=3 cellpadding=2 cellspacing=5 width="80%" height="80%" bgcolor=white borderColor=#8080FF style="margin-bottom: 1px;" >
        <tr>
          <td align=center valign=center nowrap>
            <form action="role_man.asp" method="post">
            <input class="button" name="_action" type="submit" style="width:200px;" value="儲存目前的角色設定"><br><br>
<% 
  function IsNumberChar(Ch)
  {
    return ((Ch >= '0') && (Ch <= '9'));
  }
  function IsSubPage(FileName)
  {
    for (var i=FileName.length-1; i>0; i--)
      if (FileName.charAt(i) == '_')
        return false;
      else if (!IsNumberChar(FileName.charAt(i)))
        return true;
  }
  function SearchAllValidAspFiles(dir)
  {
    var VisiblePages = new Array();
    var fso, f, fc, s;
    
    fso = new ActiveXObject("Scripting.FileSystemObject");
    f = fso.GetFolder(dir);
    fc = new Enumerator(f.files);
    
    var tt;
    
    for (var i=0; !fc.atEnd(); fc.moveNext())
    {
      s = "" + fc.item();
      ExtFileName = ExtractFileExtName(s);
      FileName = ExtractFileName(s);
      FileName = FileName.substr(0, FileName.length-ExtFileName.length-1);
      if ((ExtFileName == "asp") && 
          (FileName.substring(0, 2) == "pg") &&
          !IsSubPage(FileName))
        VisiblePages[i++] = FileName;
    }
    
    return (VisiblePages);
  }

  var SectorStr = '';

%>
  <script language="JavaScript">
  <!--
    function SetVisible(ID, Visible)
    {
      if (Visible)
        eval('document.all.r' + ID + '.style.backgroundColor="#ffff00";');
      else
        eval('document.all.r' + ID + '.style.backgroundColor="#606060";');
    }
  -->
  </script>
  <table border=1 cellpadding=2 cellspacing=0 align=center bgcolor=white borderColorDark=white borderColorLight=black>
<%
  var RoleIDs = new Array();
  var RoleNames = new Array();
  var QryCode = SQLExecute("select code_id, code_content from webap_code where code_kind='S0' and code_id <> '0' order by len(code_id), code_id");
  while (!QryCode.Eof)
  {
    RoleIDs[RoleIDs.length] = ''+QryCode('code_id');
    RoleNames[RoleNames.length] = ''+QryCode('code_content');
    QryCode.moveNext;
  }
  QryCode.Close;
  QryCode = null;
  
  function ShowRoleTitle()
  {
%>
  <tr bgcolor=Silver borderColorDark=white borderColorLight=black>
  <td align=center valign=center nowrap><b>編號</b></td>
  <td align=center valign=center nowrap><b>頁面標題</b></td>
<%
    for (var i=0; i<RoleIDs.length; i++)
    {
%>
    <td align=center valign=top width=40><b><font style="font-size: 9pt;"><%=RoleIDs[i]%><br><%=RoleNames[i]%></font></b></td><%
    }
%>
  </tr>
<%
  }
  
  ShowRoleTitle();

  var VisiblePages = SearchAllValidAspFiles(ExtractFilePath(GetRealPath()));
  
  var RoleQry = SQLExecute("select role_id, role_page_filename from webap_role order by role_page_filename, len(role_id), role_id");
  
  if (VisiblePages.length > 0)
  {
    function Like(a, b)
    {
      if (a.length < b.length)
        return a == b.substr(a.length);
      if (a.length > b.length)
        return b == a.substr(b.length);
    }
    
    function GetParts(a)
    {
      var ClipPart = new Array();
      var i=0, j=0;
      
      for (; i<a.length; i++)
        if (a.charAt(i) == '_')
        {
          ClipPart[ClipPart.length] = a.substr(j, i-j);
          j = i+1;
        }
      ClipPart[ClipPart.length] = a.substr(j, i-1);
      
      return ClipPart;
    }
    
    function SortFunc(a, b)
    {
      var ClipA = GetParts(a.substr(2, 255));
      var ClipB = GetParts(b.substr(2, 255));
      
      if (ClipA.length > ClipB.length)  return 1;
      else if (ClipA.length < ClipB.length)  return -1;
      else 
      {
        for (var i=0; i<ClipA.length; i++)
        {
          if (1*ClipA[i] > 1*ClipB[i])  
            return 1;
          else if (1*ClipA[i] < 1*ClipB[i])  
            return -1;
        }
        return 0;
      }
    }
    
    VisiblePages.sort(SortFunc);
  
    SectorStr = (''+VisiblePages[0]).substr(0,5);
    
    function RoleVisible(RoleID, PageID)
    {
      if (!RoleQry.Eof && RoleQry('role_page_filename') == PageID && RoleQry('role_id') == RoleID)
      {
        RoleQry.moveNext;
        return true;
      }
      else 
      {
        if (RoleQry.Eof)
          RoleQry.moveFirst;
        while (!RoleQry.Eof)
        {
          if (RoleQry('role_page_filename') == PageID && RoleQry('role_id') == RoleID)
          {
            RoleQry.moveNext;
            return true;
          }
          RoleQry.moveNext;
        }
        return false;
      }
    }

    var j=0, i=0;
    
    for (; i<VisiblePages.length; i++)
    {
        if (SectorStr != (''+VisiblePages[i]).substr(0,5))
        {
          Response.Write('<tr bgcolor="#c0c0ff">\n');
          Response.Write('<td colspan=2 align=right><font style="font-size: 9pt;">選擇此段<b>"' + SectorStr + '*"</b>頁面</font></td>');

          for (rid=0; rid<RoleIDs.length; rid++)
          {
            Response.Write('<td align=center>');
            Response.Write('<input type="checkbox" onclick="');
            
            RoleIDKey = RoleIDs[rid] + '_' + i;
            for (l=j; l<i; l++)
            {
              RoleIDKey = RoleIDs[rid]+'_'+l;
              Response.Write('document.all.select'+RoleIDKey+'.checked=this.checked;SetVisible(\''+RoleIDKey+'\', this.checked);');
            }
            Response.Write('"></td>\n');
          }
          Response.Write('</tr>\n');
          
          SectorStr = (''+VisiblePages[i]).substr(0,5);
          
          j = i;
          
          ShowRoleTitle();
        }
        
      Response.Write('<tr><td>');
      Response.Write('<font style="font-size: 9pt;">' + VisiblePages[i] + '</font>');
      Response.Write('</td><td bgcolor="#ffffff" nowrap>');
      Response.Write('<font color=black style="font-size: 9pt;">' + GetPageTitle(ExtractFilePath(GetRealPath()) + '\\' + VisiblePages[i] + '.asp') + '</font>');
      
      for (rid=0; rid<RoleIDs.length; rid++)
      {
        IsRoleVisible = RoleVisible(RoleIDs[rid], VisiblePages[i]);
        
        RoleIDKey = RoleIDs[rid] + '_' + i;
        
%></td>
  <td bgcolor="<%=(IsRoleVisible?'#ffff00':'#606060')%>" nowrap id="r<%=RoleIDKey%>" align=center><input 
      type="checkbox" id="select<%=RoleIDKey%>" name="selectrowguid<%=RoleIDs[rid]%>" value="<%=VisiblePages[i]%>" <%=(IsRoleVisible?'checked':'nochecked')%>
          onclick="SetVisible('<%=RoleIDKey%>', this.checked);"><%
      }
      Response.Write('</td></tr>\n');
    }

    if (j > 0)
      if (SectorStr != (''+VisiblePages[i]).substr(0,5))
      {
        Response.Write('<tr bgcolor="#c0c0ff">\n');
        Response.Write('<td colspan=2 align=right><font style="font-size: 9pt;">選擇此段<b>"' + SectorStr + '*"</b>頁面</font></td>');

        for (rid=0; rid<RoleIDs.length; rid++)
        {
          Response.Write('<td align=center>');
          Response.Write('<input type="checkbox" onclick="');
          
          RoleIDKey = RoleIDs[rid] + '_' + i;
          for (l=j; l<i; l++)
          {
            RoleIDKey = RoleIDs[rid]+'_'+l;
            Response.Write('document.all.select'+RoleIDKey+'.checked=this.checked;SetVisible(\''+RoleIDKey+'\', this.checked);');
          }
          Response.Write('"></td>\n');
        }
        Response.Write('</tr>\n');
        
        SectorStr = (''+VisiblePages[i]).substr(0,5);
        
        j = i;
      }
  }
  
  RoleQry.Close();
  RoleQry = null;

  TableDataFooter();
%>
            <br>
            <input class="button" type="submit" name="_action" style="width:200px;" value="儲存目前的角色設定"><br><br>
            </form>
          </tr>
        </td>
      </table>
      <br>
      <input class="button" type="button" value="回選單頁" style="width:200px;" onclick="location.href='sys_menu.asp'">
    </td>
  </tr>
</table>

</body>

</html>
