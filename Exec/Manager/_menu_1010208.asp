<%
  var MenuIDs = new Array();

  function WriteMenuItem(fileName, MenuName, Target)
  {
    if (Target == null)
      Target = 'content';
      
    if ((ExtractFileExtName(fileName) == "asp") && 
        (fileName.substring(0, 2) == "pg"))
    {
      if (FindInArray(Session("visible_page"), fileName.substr(0, fileName.length-4)) == -1)
        return '';
    }
    
    return '<tr>\n' + 
        '  <td align=left><img alt border="0" src="images/MenuIcon' + SysMenuIconClass + 'b.gif"></td><td width="100%"><font size="2"><a class=menubutton href="' + fileName + '" target="' + Target + '" onMouseDown="BtnDown(this);" onMouseUp="BtnUp(this);" onMouseOver="BtnMouseOver(this);" onMouseOut="BtnMouseOut(this);">' + MenuName + '</a></font></td>\n' + 
        '</tr>\n';
  }

  function WriteMenu(MenuID, MenuName, MenuCmds)
  {
    if ((MenuCmds != null) && (MenuCmds != '') && (MenuCmds.substr(0, 5) != '<span'))
    {
      MenuIDs[MenuIDs.length] = MenuID;
      
      return '\n<!-- MenuID = ' + MenuID + ' -->\n' +
          '<tr>\n' +
          '  <td colspan="2"><table border="0" cellpadding="0" cellspacing="0"><tr><td align=left><img alt border="0" src="images/MenuIcon' + SysMenuIconClass + 'a.gif"></td><td align=left><a class=menubutton href="javascript:SetDisplay(' + MenuID + ')" target="_self" onMouseDown="BtnDown(this);" onMouseUp="BtnUp(this);" onMouseOver="BtnMouseOver(this);" onMouseOut="BtnMouseOut(this);">' + MenuName + '</a></td></tr></table></td>\n' +
          '</tr>\n' +
          '<tr id="' + MenuID + '" style="display: none">\n' +
          '  <td width="10">&nbsp;</td>\n' + 
          '  <td>\n' +
          '    <table border="0" cellpadding="0" cellspacing="1" width="165">\n' +
          MenuCmds +
          '    </table>\n' + 
          '  </td>\n' + 
          '</tr>\n';
    }
    else
      return '';
//      return '<span id=' + MenuID + ' style="display: none;">' + MenuCmds + '</span>';
  }
  
  function WriteMenuTable()
  {
    var HtmlCmd = '';
  
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
  
  HtmlCmd =
      WriteMenu('m1', '復查決定書',
        WriteMenuItem('pg1_1_1.asp', '查詢作業') +
        WriteMenuItem('pg1_1_2.asp', '資料維護')
      ) +
      WriteMenu('m2', '訴願決定書',
        WriteMenuItem('pg2_1_1.asp', '查詢作業') +
        WriteMenuItem('pg2_1_2.asp', '資料維護')
      ) +
      WriteMenu('m3', '行政訴訟裁判書',
        WriteMenuItem('pg3_1_1.asp', '查詢作業') +
        WriteMenuItem('pg3_1_2.asp', '資料維護')
      ) +
      WriteMenu('m4', '資料管理',
        WriteMenuItem('pg9_1_1.asp', '稅目維護') +
        WriteMenuItem('pg9_1_2.asp', '項目維護') +
        WriteMenuItem('pg1_1_3.asp', '關鍵字維護') +
        WriteMenuItem('pg1_1_4.asp', '作業紀錄查詢')
      ) +
//      WriteMenuItem('user_password.asp', '更改密碼') +
        WriteMenuItem('help_query.asp', '使用說明') +
        WriteMenuItem('logout.asp', '登出', '_top');
    
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

%>
<style>
a:hover      
{ 
  background-color: #ffffe0;
  color: black;
  text-decoration: none
}
a:active     
{
  color: black;
  text-decoration: none
}
a:visited    
{
  color: black;
  text-decoration: none
}
a:link       
{
  color: black; 
  text-decoration: none;
}
a            
{ 
  color: black; 
  text-decoration: none 
}
.menubutton
{
  background-color: #ffffff;
  color: black;
  font-family: 細明體;
  font-size: 11pt;
  border-top: 1px solid #ffffff;
  border-left: 1px solid #ffffff;
  border-right: 1px solid #ffffff;
  border-bottom: 1px solid #000000;
  margin: 1pt;
  height: 12pt;
  cursor: hand
}
</style>

<script language="javascript">
<!--
  function SetDisplay(Menu)
  {
<%
  for (var i=0; i<MenuIDs.length; i++)
    Response.Write('    if (Menu.id.substr(0, ' + MenuIDs[i].length + ') == "' + MenuIDs[i] + '") ' + MenuIDs[i] + '.style.display = "";\n' + 
          '    else ' + MenuIDs[i] + '.style.display = "none";\n');
%>  }
  
  function BtnDown(obj)
  {
    obj.style.backgroundColor="#ffe000";
    obj.style.borderTop="1px solid #000000";
    obj.style.borderLeft="1px solid #000000";
    obj.style.borderRight="1px solid #e0e0e0";
    obj.style.borderBottom="1px solid #e0e0e0";
  }
  function BtnUp(obj)
  {
    obj.style.backgroundColor="#ffffe0";
    obj.style.borderTop="1px solid #e0e0e0";
    obj.style.borderLeft="1px solid #e0e0e0";
    obj.style.borderRight="1px solid #000000";
    obj.style.borderBottom="1px solid #000000";
  }
  function BtnMouseOver(obj)
  {
    obj.style.backgroundColor="#ffff00";
    obj.style.borderTop="1px solid #e0e0e0";
    obj.style.borderLeft="1px solid #e0e0e0";
    obj.style.borderRight="1px solid #000000";
    obj.style.borderBottom="1px solid #000000";
  }
  function BtnMouseOut(obj)
  {
    obj.style.backgroundColor="#ffffff";
    obj.style.borderTop="1px solid #ffffff";
    obj.style.borderLeft="1px solid #ffffff";
    obj.style.borderRight="1px solid #ffffff";
    obj.style.borderBottom="1px solid #000000";
  }
-->
</script>

<%
    Response.Write(HtmlCmd);
  }

%>