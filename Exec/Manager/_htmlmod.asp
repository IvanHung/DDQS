<%
  var SkipErr = false;
  var SysMsgHistory = '';
  
  MaxUIArrayCount = 5;

  var MsgTitle = '執行中';
  var SysSubFuncTitle = '';
  var CurrentFormName = 'mainform';
  
  function SetHeader(SubFuncTitle)
  {
    if (SubFuncTitle != null)
      SysSubFuncTitle = SubFuncTitle;
  
    if (IsNull(SysSubFuncTitle))
      MsgTitle = SysTitle;
    else
      MsgTitle = SysTitle + ' - ' + SysSubFuncTitle;
  }
  
  function HtmlHeader(SubFuncTitle)
  {
    SetHeader(SubFuncTitle);
    
    Response.Write('\n<!-- HtmlHeader() Begin -->\n');
    Response.Write('  <head>\n');
    Response.Write(SysHtmlHeader + '\n');
      
    Response.Write('  <title>' + MsgTitle + '</title>\n');
    Response.Write('  </head>\n');
    
%>
  <script language='javascript' src='_chkfunc.js'></script>
  <script language="javascript">
  <!--
    MsgTitle = '<%=MsgTitle%>';
    OnLoadHookCmd = '';

    function WhenDocLoad()
    {
      if ((document.forms.length > 0) && (document.forms(0).elements.length > 0))
        for (var i=0; i<document.forms(0).elements.length; i++)
          if (document.forms(0).elements(i).type != "hidden" && document.forms(0).elements(i).style.display != 'none')
          {
            document.forms(0).elements(i).focus();
            break;
          }
      if (OnLoadHookCmd != '')
        eval(OnLoadHookCmd);
    }

    window.onload = WhenDocLoad;
  //-->
  </script>
<%
    Response.Write('<!-- HtmlHeader() End -->\n');
  }

  function ContentHeader()
  {
    Response.Write('\n<!-- ContentHeader() Begin -->\n');
    Response.Write('  <tr id=_ContentHeader>\n');
    Response.Write('    <td class=pagetableHeader align=center>\n');
   
    if (!IsNull(SysHeaderBanner))
      Response.Write('<img src="' + SysRootPath + '/images/' + SysHeaderBanner + '"><br>');
      
    if (IsNull(SysHeaderBanner))
      Response.Write(SysTitle);
      
    if (SysSubFuncTitle != '')
      Response.Write('<br><font style="font:11pt arial;"><b>' + SysSubFuncTitle + '</b></font>');
      
    if (DebugMode)
      Response.Write('<br><font style="font-family: 新細明體; font-size: 12pt;">[偵錯模式] ' + CurrentUrl() + ' (' + Session('user_id') + '.' + Session('user_name') + ')</font>');

    Response.Write('<br>');
    
    if (Session('user_role_id') != '0')
      Response.Write('<input type=button class=topbutton style="width:70px;background-color:#FFFF00;color:#C00000;" value="▼ 選單" onclick="_MenuTable.style.display=(_MenuTable.style.display==\'\'?\'none\':\'\');if (_MenuTable.style.display==\'\') {_MenuTable.style.left=window.event.clientX+5;_MenuTable.style.top=window.event.clientY+5;InputVisible(false);} else {InputVisible(true);}"> ');
      
    Response.Write('<input type=button class=topbutton style="width:340px;" value="資料時間:' + CHDateToStr() + ' ' + CHTimeToStr() + ' / 重新整理" onclick="location.reload()"> ');
    Response.Write('<input type=button class=topbutton style="width:70px;background-color:#A0FFA0;color:black;" value="列印本頁" onclick="PrintCurPage();"> ');
    Response.Write('<input type=button class=topbutton style="width:70px;background-color:#FFFF00;color:#C00000;" value="登出 ▲" onclick="top.location.href=\'logout.asp\';">');
    Response.Write('</td>\n');
    Response.Write('  </tr>\n');

    var user_role_name = GetSelectText("select code_content from webap_code where code_kind = 'S0' and code_id = '" + Session('user_role_id') + "'");
      
    if (!IsNull(Session('user_role_name')))
      user_role_name += '/' + Session('user_role_name');
    
    Response.Write('<tr style="height=20px;"> \n');
    Response.Write('  <td height="10" bgcolor="#3366CC"><font color="#FFFFFF">使用者：[' + user_role_name + '] ' + Session('user_id') + ' ' + Session('user_name') + ' ' + '</font></td>\n');
    Response.Write('</tr>\n');

    if (Session('user_role_id') != '0')
    {
      Response.Write('  <tr>\n');
      Response.Write('    <td align=center>');
      Response.Write('<table id=_MenuTable style="position:absolute;left=200;top=60;display:none;background-color:4374B0;border-style:solid;border-width:1;border-color:white black black white;padding:1;" cellpadding="0" cellspacing="0" width="200">\n');
      Response.Write('<tr>\n');
      Response.Write('  <td align=left colspan=2 style="font: 14pt \'新細明體\';color:white;background-color: #000080;"><b>- 選單-</b></td>\n');
      Response.Write('</tr>\n');
      WriteMenuTable();
      Response.Write('<tr>\n');
      Response.Write('  <td align=left><img alt border="0" src="images/MenuIcon' + SysMenuIconClass + 'b.gif"></td><td width="100%"><font size="2"><a class=menubutton href="frame.asp?show_left_menu=true" target="_top" onMouseDown="BtnDown(this);" onMouseUp="BtnUp(this);" onMouseOver="BtnMouseOver(this);" onMouseOut="BtnMouseOut(this);">永遠顯示選單</a></font></td>\n');
      Response.Write('</tr>\n');
      Response.Write('</table>\n');
      Response.Write('</td>\n');
      Response.Write('  </tr>\n');
    }
%>
<script language="javascript">
<!--
  if (window.name == '_print')
    _ContentHeader.style.display = "none";
//--> 
</script>
<%
    Response.Write('<!-- ContentHeader() End -->\n');
  }
  
  function TableDataHeader(fieldNameArray, alignArray)
  {
    Response.Write('\n<!-- TableDataHeader() Begin -->\n');
    Response.Write("<table border=1 cellpadding=2 cellspacing=0 align=center bgcolor=white borderColorDark=white borderColorLight=black>\n");
    
    var align;
    if (fieldNameArray != null)
    {
      Response.Write("<tr bgcolor=Silver borderColorDark=white borderColorLight=black>\n");
      for (var i=0; i<fieldNameArray.length; i++)
      {
        align = 'middle';
        if ((alignArray != null) && (i < alignArray.length))
        {
          if (alignArray[i] == 'r')
            align = 'right';
          else if (alignArray[i] == 'l')
            align = 'left';
        }
        if (IsNull(fieldNameArray[i]))
          fieldNameArray[i] = "&nbsp;";
        Response.Write("<td align=" + align + " valign=center nowrap><b>" + fieldNameArray[i] + "</b></td>\n");
      }
      Response.Write("</tr>\n");
    }
    Response.Write('\n<!-- TableDataHeader() End -->\n');
    TableDataBodyColor = "#FFFFFF";
  }
  
  function TableDataBody(fieldDataArray, alignArray)
  {
    Response.Write('\n<!-- TableDataBody() Begin -->\n');
    if (fieldDataArray != null)
    {
      var align;
      Response.Write('<tr bgcolor="' + TableDataBodyColor + '">\n');
      for (var i=0; i<fieldDataArray.length; i++)
      {
        align = 'middle';
        if ((alignArray != null) && (i < alignArray.length))
        {
          if (alignArray[i] == 'r')
            align = 'right';
          else if (alignArray[i] == 'l')
            align = 'left';
        }
        if (IsNull(fieldDataArray[i]))
          Response.Write("<td align=" + align + " valign=center nowrap><b>&nbsp;</b></td>\n");
        else
          Response.Write("<td align=" + align + " valign=center nowrap><b>" + fieldDataArray[i] + "</b></td>\n");
      }
      Response.Write("</tr>\n");
      
      if (TableDataBodyColor == "#FFFFFF")
        TableDataBodyColor = "#FFFFC0";
      else
        TableDataBodyColor = "#FFFFFF";
    }
    Response.Write('\n<!-- TableDataBody() End -->\n');
  }
  
  function TableDataFooter()
  {
    Response.Write('\n<!-- TableDataFooter() Begin -->\n');
    Response.Write("</table>\n");
    Response.Write('\n<!-- TableDataFooter() End -->\n');
  }
  
  function BrowseData(sql, fieldArray, fieldNameArray, detailLink, allowInsert, InsertExt, countSql, checkedExecLink, scrollDataHook, checkedCaption, sortOption)
  {
    var StartLoc = 0;
    var ShowCount = SysBrowseCount;
    var ColCount = 0;
    var TotalCount = 0;
    var Loc = 0;
    
    CurrentFormName += 'X';

    if (IsNull(sql))
      return;
      
    Response.Write('\n<!-- BrowseData() Begin -->\n');
    
    SortKey = Rcv.Item('_SortKey');
    
    if (!IsNull(SortKey))
    {
      if (PosStr(sql.toUpperCase(), 'ORDER BY'))
        sql = sql.substr(0, PosStr(sql.toUpperCase(), 'ORDER BY'));

      if (SortKey.substr(0, 3) == 'dec')
        sql = sql + " order by " + (SortKey.substr(3, 5)*1+1) + ' desc';
      else
        sql = sql + " order by " + (SortKey.substr(3, 5)*1+1);
    }
    
    var Qry = SQLExecute(sql);
    
    TotalCount = Qry.RecordCount;
    
    if (!IsNull(Rcv.Item('_BrowseLocation')))
      StartLoc = Rcv.Item('_BrowseLocation')*1;
      
    if ((StartLoc != -1) && (StartLoc < 0))
      StartLoc = 0;
      
    if ((StartLoc == -1) || (StartLoc > TotalCount))
      StartLoc = Math.max(TotalCount - ShowCount, 0);
    
    Response.Write('<!-- Show data between ' + StartLoc + ' and ' + Math.min(StartLoc + ShowCount, TotalCount) + ' -->\n');
    
    if (!IsNull(checkedExecLink))
    {
      if (checkedCaption == null)
        Response.Write('<form action="' + checkedExecLink + '" id="' + CurrentFormName + '" method="post" name="' + CurrentFormName + '" onsubmit="return(window.confirm(\'請問您確定要刪除所選擇的資料嗎?\'));">');
      else
        Response.Write('<form action="' + checkedExecLink + '" id="' + CurrentFormName + '" method="post" name="' + CurrentFormName + '">');
    }
      
    Response.Write('\n<a name="browsedatatop">\n');
    Response.Write("<table border=1 cellpadding=1 cellspacing=0 align=center CLASS=borwsetable>\n");

    if (fieldArray == null)
    {
      fieldArray = new Array();
      for (var i=0; i<Qry.Fields.Count; i++)
        fieldArray[i] = '' + Qry.Fields(i).Name;
    }
        
    if (fieldNameArray == null)
      fieldNameArray = fieldArray;
    
    Response.Write("<tr bgcolor=Silver borderColorDark=white borderColorLight=black>\n");
    Response.Write("<td nowrap style=\"width: 20px;\">&nbsp;</td>\n");

%>
  <script language="javascript">
  <!--
  function RIn(No)
  {
    eval('document.all.Row' + No + '.style.backgroundColor=0xFF80A0;');
  }
  function ROut(No)
  {
    eval('document.all.Row' + No + '.style.backgroundColor=0xFFFFFF;');
  }
  -->
  </script>
<%

    if (!IsNull(checkedExecLink))
    {
%>
  <script language="javascript">
  <!--
  function AllCheck(checked)
  {
    for (var i=0; i<<%=CurrentFormName%>.length; i++)
      if (<%=CurrentFormName%>.elements(i).name.substr(0, 10) == 'checkedrow')
        <%=CurrentFormName%>.elements(i).checked = checked;
  }
  -->
  </script>
<%
      Response.Write('<td class=header nowrap><input type="checkbox" onclick="AllCheck(this.checked);" onMouseEnter="window.status=\'選取全部 / 取消選取全部\'" onMouseLeave="window.status=\'\';"></td>\n');
    }

    OldSortKey = Rcv.Item('_SortKey');

    for (var i=0; i<fieldNameArray.length; i++)
    {
      Rcv.SetItem('_BrowseLocation', '0');

      %><td class=header align=middle valign=center nowrap><%=fieldNameArray[i]%><br><%

      Rcv.SetItem('_SortKey', 'inc' + i);
      
      if (sortOption)
      {
        if (OldSortKey == Rcv.Item('_SortKey'))
        {
          %><font color=red>▲</font><%
        }
        else
        {
          %><a href="<%=CurrentUrl()%>?<%=Rcv.GetAllQuest()%>#browsedatatop">▲</a><%
        }
  
        Rcv.SetItem('_SortKey', 'dec' + i);
        if (OldSortKey == Rcv.Item('_SortKey'))
        {
          %><font color=red>▼</font><%
        }
        else
        {
          %><a href="<%=CurrentUrl()%>?<%=Rcv.GetAllQuest()%>#browsedatatop">▼</a><%
        }
        %></td>
        <%
      }
    }
    Response.Write("</tr>\n");

    Rcv.SetItem('_SortKey', OldSortKey);
    
    ColCount = fieldNameArray.length;

    if (!IsNull(checkedExecLink))
      ColCount++;
      

    if (allowInsert && !IsNull(detailLink))
    {
%><tr><td align="right" valign="center" bgcolor="Silver" borderColorDark="white" borderColorLight="black" nowrap><a href="<%=detailLink%>?<%=InsertExt%>"><img src="<%=SysRootPath%>/images/BrowIcon.gif" border="0" align="absmiddle" hspace="0"></a></td><td align="left" valign="center" colspan="<%=ColCount%>" nowrap><a href="<%=detailLink%>?<%=InsertExt%>"><i><b><font color="#000000">新增</font></b></i></a></td></tr>
<%
    };

    var RealShowCount = 0;
    
    if (Qry.eof)
    {
%><tr><td align="center" valign="center" colspan="<%=ColCount+1%>" nowrap><font color=#202020>[無]</font></td></tr>
<%
    }
    else
    {
      Qry.move(StartLoc);
      
      if (Qry.eof)
        Qry.move(-ShowCount);
    
      for (Loc = 0; !Qry.Eof && Loc < ShowCount; Loc++)
      {
        RealShowCount++;
        
        StateHint = '';
        RowReadOnly = false;
        if (IsNull(detailLink))
          LinkCmd = '<a >';
//          LinkCmd = '<a onMouseEnter="RIn(' + Loc + ');" onMouseLeave="ROut(' + Loc + ');">';
        else
          LinkCmd = '<a href="' + detailLink + '?rowguid=' + Server.URLEncode(''+Qry("rowguid")) + '">';
//          LinkCmd = '<a href="' + detailLink + '?rowguid=' + Server.URLEncode(''+Qry("rowguid")) + '" onMouseEnter="RIn(' + Loc + ');" onMouseLeave="ROut(' + Loc + ');">';

        var IsChecked = false;
        
        if (scrollDataHook!=null)
          eval(''+scrollDataHook);
        
        if (RowReadOnly)
          Response.Write('<tr bgcolor=#' + (Loc%2==1?'ededed':'ffffff') + ' onmouseover="this.style.backgroundColor=\'ffffac\';" onmouseout="this.style.backgroundColor=\'\';">\n');
        else
          Response.Write('<tr id="Row' + Loc + '" bgcolor=#' + (Loc%2==1?'ededed':'ffffff') + ' onmouseover="this.style.backgroundColor=\'ffffac\';" onmouseout="this.style.backgroundColor=\'\';">\n');
        
        if (!RowReadOnly && !IsNull(detailLink) && FindInArray(fieldArray, "rowguid") && !IsNull(Qry("rowguid")))
        {
%><td align="right" valign="center" bgcolor="Silver" nowrap style="width: 20px;"><%=LinkCmd%><b><%=StartLoc+Loc+1%></b><!--img src="<%=SysRootPath%>/images/BrowIcon.gif" border="0" align="absmiddle" hspace="0"--><font style="font-size=9pt;" color="#000000"><%=StateHint%></font></a></td>
<%
        }
        else
        {
%><td align="right" valign="center" bgcolor="Silver" nowrap style="width: 20px;"><b><%=StartLoc+Loc+1%></b><!--img src="<%=SysRootPath%>/images/BrowIcon.gif" border="0" align="absmiddle" hspace="0"--><font style="font-size=9pt;" color="#000000"><%=StateHint%></font></td>
<%
        }
      
        if (!IsNull(checkedExecLink))
          if (!RowReadOnly)
            Response.Write('<td nowrap><input type="checkbox" name="checkedrow' + Loc + '" id="checkedrow' + Loc + '" value="' + Qry("rowguid") +  '" ' + (IsChecked?"checked":"") + ' onMouseEnter="window.status=\'選取 / 取消選取\';RIn(' + Loc + ');" onMouseLeave="window.status=\'\';ROut(' + Loc + ');"></td>\n');
          else
            Response.Write('<td nowrap><input type="checkbox" DISABLED></td>\n');
        
        for (var i=0; i<fieldArray.length; i++)
        {
          if (IsNull(Qry(fieldArray[i])) || (RTrimCh(''+Qry(fieldArray[i]), ' ')==''))
            Response.Write("<td align=left valign=center nowrap><font color=#202020>[無]</font></td>\n");
          else
          {
            if (RowReadOnly)
              Response.Write("<td align=left valign=center nowrap><font color=#ffffff>");
            else
              Response.Write("<td align=left valign=center nowrap><font color=#000080>" + LinkCmd);
              
            if (Qry(fieldArray[i]).Type == 135) // 日期型態資料
              Response.Write(CHDateToStr(Qry(fieldArray[i]))); // + " " + CHTimeToStr(Qry(fieldArray[i])));
            else
              Response.Write(Qry(fieldArray[i]));
              
            Response.Write("</a></font></td>\n");
          }
        }
        
        Response.Write("</tr>\n");
        Qry.moveNext;
      }
    };
    
    if (!IsNull(checkedExecLink))
    {
%><tr><td align="center" valign="center" bgcolor="Silver" borderColorDark="white" borderColorLight="black" nowrap colspan="<%=ColCount+1%>"><%
      if (checkedCaption == null)
        checkedCaption = '刪除所選項目';
      Response.Write('<input type="submit" class=bwbutton value="' + checkedCaption + '">');
%></td></tr>
<%
    }
%>
<tr><td align="left" valign="center" bgcolor="Silver" borderColorDark="white" borderColorLight="black" nowrap colspan="<%=ColCount+1%>">[共<%=TotalCount%>筆/本頁顯示<%=RealShowCount%>筆] &nbsp;&nbsp;
<%
    if ((StartLoc > 0) || (!Qry.eof))
    {
      if (StartLoc > 0)
      {
        Rcv.SetItem('_BrowseLocation', '0');
%><input type=button value='第一頁' class=bwbutton onclick="location.href='<%=CurrentUrl()%>?<%=Rcv.GetAllQuest()%>#browsedatatop'"><%
        Rcv.SetItem('_BrowseLocation', ''+(Math.max(1*StartLoc-(ShowCount*5), 0)));
%><input type=button value='上五頁' class=bwbutton onclick="location.href='<%=CurrentUrl()%>?<%=Rcv.GetAllQuest()%>#browsedatatop'"><%
        Rcv.SetItem('_BrowseLocation', ''+(Math.max(1*StartLoc-ShowCount, 0)));
%><input type=button value='上一頁' class=bwbutton onclick="location.href='<%=CurrentUrl()%>?<%=Rcv.GetAllQuest()%>#browsedatatop'"><%
      }
      else
      {
%><input type=button value='第一頁' class=bwbutton disabled><%
%><input type=button value='上五頁' class=bwbutton disabled><%
%><input type=button value='上一頁' class=bwbutton disabled><%
      }
      
      if (!Qry.eof)
      {
        Rcv.SetItem('_BrowseLocation', ''+(1*StartLoc+ShowCount));
%><input type=button value='下一頁' class=bwbutton onclick="location.href='<%=CurrentUrl()%>?<%=Rcv.GetAllQuest()%>#browsedatatop'"><%
        Rcv.SetItem('_BrowseLocation', ''+(1*StartLoc+(ShowCount*5)));
%><input type=button value='下五頁' class=bwbutton onclick="location.href='<%=CurrentUrl()%>?<%=Rcv.GetAllQuest()%>#browsedatatop'"><%
        Rcv.SetItem('_BrowseLocation', '-1');
%><input type=button value='最後一頁' class=bwbutton onclick="location.href='<%=CurrentUrl()%>?<%=Rcv.GetAllQuest()%>#browsedatatop'"><%
      }
      else
      {
%><input type=button value='下一頁' class=bwbutton disabled><%
%><input type=button value='下五頁' class=bwbutton disabled><%
%><input type=button value='最後一頁' class=bwbutton disabled><%
      }
    }
%>
</td></tr>
<%

    Response.Write("</table>\n");
    
    if (!IsNull(checkedExecLink))
      Response.Write('</form>');
      
    if (!IsNull(GetPagesHome()))
    {
%><center><input type=button value='重新查詢' class="button" onClick="location.href='<%=GetPagesHome()%>'"></center><%
    }

    Response.Write('\n<!-- BrowseData() End -->\n');
    
    Qry.Close;
    Qry = null;
  }
  
  var TableDataBodyColor = "#FFFFFF";
  
  function ProcessingMessage(msg)
  {
    var MTitle = "訊息";
      
    if (IsNull(msg))
      var MMsg = "作業訊息";
    else
      var MMsg = msg;
      
    Response.Clear;

%><html>
<head>
<%=SysHtmlHeader%>
<title><%=MTitle%></title>
</head>
<body>
<%
    Response.Write('\n<!-- ProcessingMessage() Begin -->\n');
%>
<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%" id="ProcessingMessage">
  <%
    Response.Write('\n<!-- ContentHeader() Begin -->\n');
    Response.Write('  <tr id=_ContentHeader>\n');
    Response.Write('    <td height=60>\n');
    Response.Write('      <table border=0 cellpadding=2 cellspacing=0 align=center bgcolor=#FFFFFF width="100%" height="100%">\n');
    ContentHeader();
    Response.Write('      </table>\n');
    Response.Write('    </td>\n');
    Response.Write('  </tr>\n');
    Response.Write('<!-- ContentHeader() End -->\n');
  %>
  <tr>
    <td align="middle" nowrap valign="center">
      <p>
      <table border="0" cellpadding="1" cellspacing="1" height="80%" width="80%">
      <tr>
        <td align="center" valign="center"><b><%=MMsg%></b><br></td>
      </tr>
      </table>
      </p>
    </td>
  </tr>
</table>
<%
    Response.Write('\n<!-- ProcessingMessage() End -->\n');

    Response.Flush();
  }
  
  function CloseProcessingMessage()
  {
%>
<script language="JavaScript">
<!--
  document.all.ProcessingMessage.style.display = "none";
-->
</script>
<%

    Response.Flush();
  }
  
  var IsFirstMsg = true;
  
  function CustomMessage(title, msg, ButtonArray)
  {
    if (IsNull(title))
      var MTitle = "訊息";
    else
      var MTitle = title;
      
    if (IsNull(msg))
      var MMsg = "作業訊息";
    else
      var MMsg = msg;
    
    if (IsFirstMsg)
    {
      Response.Clear;
%>
<html>
<head>
<%=SysHtmlHeader%>
<title><%=MTitle%></title>
</head>
<body><%
    Response.Write('\n<!-- CustomMessage() Begin -->\n');
%><table border="0" class=pagetable cellpadding="1" cellspacing="1" width="100%">
  <%
    ContentHeader();
  %>
<%
      IsFirstMsg = false;
    }
    else
    {
%>
<table border="0" class=pagetable cellpadding="1" cellspacing="1" width="100%">
<%
    }
%>  
  <tr>
    <td align="middle" nowrap valign="center">
      <br>
      <table border=3 cellpadding=2 cellspacing=5 width="80%" height="80%" bgcolor=white borderColor=#8080FF style="margin-bottom: 1px;" >
        <tr>
          <td align=center valign=center nowrap>
            <p>
            <table border="0" cellpadding="1" cellspacing="1" height="80%" width="80%">
            <tr>
              <td align="center" valign="center"><b><%=SysMsgHistory%><%=MMsg%></b><br><br><%
          if (ButtonArray == null)
          {
      %><input class="button" type="button" value="回上一頁" onClick="history.go(-1)" id="btnBack" name="btnBack"><%
      %>
      <script language="javascript">
      <!--
         document.all.btnBack.focus();
      -->
      </script>
      <%
          }
          else
          {
            for (var i=0; i<ButtonArray.length; i+=2)
            {
      %><input class="button" type="button" value="<%=ButtonArray[i]%>" onClick="<%=ButtonArray[i+1]%>" id="btn<%=i%>" name="btn<%=i%>"><%
            }
      %>
      <script language="javascript">
      <!--
         document.all.btn0.focus();
      -->
      </script>
      <%
          }
      %>
          </tr>
        </td>
      </table>
</td></tr></table></p></p></td></tr></table><%
    Response.Write('\n<!-- CustomMessage() End -->\n');
    
%></body>
</html>
<%
    Response.End;
  }
  
  function ShowMessage(Msg, ButtonArray)
  {
    Msg = "<font style=\"font: 18pt 新細明體; background-color: #008000; color: white; height: 40px; width:200px;\"><b>處理訊息</b></font><br><br><font color=green>" + Msg + "</font>";
    
    if (IsNull(SysSubFuncTitle))
      CustomMessage(SysTitle + " - 作業訊息", Msg, ButtonArray);
    else
      CustomMessage(SysTitle + " - " + SysSubFuncTitle + " - 作業訊息", Msg, ButtonArray);
  }
  
  function ErrorMsg(Msg, ButtonArray)
  {
    Msg = "<font style=\"font: 18pt 新細明體; background-color: red; color: black; height: 40px; width:200px;\"><b>錯誤訊息</b></font><br><br>" + 
        "<font color=red>" + Msg + "</font>";
    
    if (SkipErr)
      SysMsgHistory += Msg + '<br><br><hr color=black width=5><br>';
    else
    {
      if (IsNull(SysSubFuncTitle))
        CustomMessage(SysTitle + " - 錯誤訊息", Msg, ButtonArray);
      else
        CustomMessage(SysTitle + " - " + SysSubFuncTitle + " - 錯誤訊息", Msg, ButtonArray);
    }
  }

  function SystemErrorMsg(Msg, Subject)
  {
    try
    {
      Msg = "<font style=\"font: 18pt 新細明體; background-color: red; color: black; height: 40px; width:200px;\"><b>嚴重錯誤訊息</b></font><br><br>" + 
          "<font color=red>此為嚴重錯誤, 請即刻通知系統管理人員.<br><br>" + Msg + "</font>";
      
      AppendLog("ERROR <br>" + Msg, 'red');
      
      if (SkipErr)
        SysMsgHistory += Msg + '<br><br><hr color=black width=100% size=5><br>';
      else
      {
        if (IsNull(SysSubFuncTitle))
          CustomMessage(SysSubFuncTitle + " - 嚴重錯誤訊息", Msg);
        else
          CustomMessage(SysTitle + " - " + SysSubFuncTitle + " - 嚴重錯誤訊息", Msg);
      }
    }
    catch (e)
    {
      DebugMsg(Msg, Subject);
    }
  }

  function ShowEnDateEdit(fieldName, defaultValue, className, readonly, ext)
  {
    if (defaultValue == null)
      var defaultValue = "";
      
    defaultValue = '' + defaultValue;
      
    if (className == null)
      var className = "text";
    
    if (ext == null)
      var ext = '';
      
    Response.Write('\n<!-- ShowEnDateEdit() Begin -->\n');
    
    if (readonly == true)
    {
      if (IsNull(defaultValue))
      {
%><font class="readonlytext">[無]</font>
<%
      }
      else
      {
%>  <font class="readonlytext">西元<input type="hidden" class="<%=className%>" size="4" value="<%=LTrimCh(defaultValue.substr(0, 4), "0")%>" readonly <%=ext%>><%=LTrimCh(defaultValue.substr(0, 4), "0")%>/<input 
    type="hidden" class="<%=className%>" size="2" value="<%=LTrimCh(defaultValue.substr(5, 2), "0")%>" readonly <%=ext%>><%=LTrimCh(defaultValue.substr(5, 2), "0")%>/<input 
    type="hidden" class="<%=className%>" size="2" value="<%=LTrimCh(defaultValue.substr(8, 2), "0")%>" readonly <%=ext%>><%=LTrimCh(defaultValue.substr(8, 2), "0")%></font>
  <input type="hidden" name="<%=fieldName%>" id="<%=fieldName%>" value="<%=defaultValue%>">
<%
      }
/*
%>  西元<input class="<%=className%>" size="4" value="<%=LTrimCh(defaultValue.substr(0, 4), "0")%>" readonly <%=ext%>>/<input 
    class="<%=className%>" size="2" value="<%=LTrimCh(defaultValue.substr(5, 2), "0")%>" readonly <%=ext%>>/<input 
    class="<%=className%>" size="2" value="<%=LTrimCh(defaultValue.substr(8, 2), "0")%>" readonly <%=ext%>>
  <input type="hidden" name="<%=fieldName%>" id="<%=fieldName%>" value="<%=defaultValue%>">
<%
*/
    }
    else
    {
%>  <script language="javascript">
  <!--
  // 組合日期欄位資料
  
  <%=fieldName%>_fyear_value = '<%=defaultValue.substr(0, 4)%>';
  <%=fieldName%>_fmonth_value = '<%=defaultValue.substr(5, 2)%>';
  <%=fieldName%>_fday_value = '<%=defaultValue.substr(8, 2)%>';
  
  function Calc_<%=fieldName%>(fyear, fmonth, fday)
  {
    if (fyear != null)
    {
      <%=fieldName%>_fyear_value = ''+fyear.value;
      if (!CheckAllNumber(<%=fieldName%>_fyear_value))
        <%=fieldName%>_fyear_value = '';
    }
    if (fmonth != null)
    {
      <%=fieldName%>_fmonth_value = ''+fmonth.value;
      if (!CheckAllNumber(<%=fieldName%>_fmonth_value))
        <%=fieldName%>_fmonth_value = '';
    }
    if (fday != null)
    {
      <%=fieldName%>_fday_value = ''+fday.value;
      if (!CheckAllNumber(<%=fieldName%>_fday_value))
        <%=fieldName%>_fday_value = '';
    }

    if ((<%=fieldName%>_fyear_value != '') && (<%=fieldName%>_fmonth_value != '') && (<%=fieldName%>_fday_value != ''))
      document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value = LPad(<%=fieldName%>_fyear_value, 4, '0') + '/' + LPad(<%=fieldName%>_fmonth_value, 2, '0') + '/' + LPad(<%=fieldName%>_fday_value, 2, '0');
    else
      document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value = '';

    if ((document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value != '') && !CheckDateStr(document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value))
      window.alert('日期資料錯誤.');
  }
  OnLoadHookCmd += " <%=fieldName%>_fyear_value = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_year.value; " + 
      " <%=fieldName%>_fmonth_value = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_month.value; " + 
      " <%=fieldName%>_fday_value = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_day.value; " + 
      " if ((<%=fieldName%>_fyear_value != '') && (<%=fieldName%>_fmonth_value != '') && (<%=fieldName%>_fday_value != '')) " +
      " document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value = LPad(<%=fieldName%>_fyear_value, 4, '0') + '/' + LPad(<%=fieldName%>_fmonth_value, 2, '0') + '/' + LPad(<%=fieldName%>_fday_value, 2, '0'); \n";
  //-->
  </script>
  西元<input class="<%=className%>" maxlength="4" name="_<%=fieldName%>_year" id="_<%=fieldName%>_year" size="4" onblur="Calc_<%=fieldName%>(this, null, null);" value="<%=LTrimCh(defaultValue.substr(0, 4), "0")%>" <%=ext%>>/<input 
  class="<%=className%>" maxlength="2" name="_<%=fieldName%>_month" id="_<%=fieldName%>_month" size="2" onblur="Calc_<%=fieldName%>(null, this, null);" value="<%=LTrimCh(defaultValue.substr(5, 2), "0")%>" <%=ext%>>/<input 
  class="<%=className%>" maxlength="2" name="_<%=fieldName%>_day" id="_<%=fieldName%>_day" size="2" onblur="Calc_<%=fieldName%>(null, null, this);" value="<%=LTrimCh(defaultValue.substr(8, 2), "0")%>" <%=ext%>>
  <!--input type="button" style="background-color: red; color: white; width=15; height=22;" onclick="var Ret=window.showModalDialog('show_calendar.asp');if (Ret != null) { document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_year.value=Ret.substr(1,2);Calc_<%=fieldName%>(document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_year, null, null);document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_month.value=Ret.substr(3,2);Calc_<%=fieldName%>(null, document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_month, null);document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_day.value=Ret.substr(5,2);Calc_<%=fieldName%>(null, null, document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_day);}"-->
  <input type="hidden" name="<%=fieldName%>" id="<%=fieldName%>" value="<%=defaultValue%>">
<%
    }
    
    Response.Write('\n<!-- ShowEnDateEdit() End -->\n');
  }

  function ShowChDateEdit(fieldName, defaultValue, className, readonly, ext)
  {
    if (defaultValue == null)
      var defaultValue = "";
      
    defaultValue = '' + defaultValue;
      
    if (className == null)
      var className = "text";
    
    if (ext == null)
      var ext = '';
      
    Response.Write('\n<!-- ShowChDateEdit() Begin -->\n');
    
    if (readonly == true)
    {
      if (IsNull(defaultValue))
      {
%><font class="readonlytext">[無]</font>
<%
      }
      else
      {
%>  <font class="readonlytext">民國<input type="hidden" class="<%=className%>" size="3" value="<%=defaultValue.substr(0, 4)==0?'':LTrimCh(defaultValue.substr(0, 4)-1911, "0")%>" readonly <%=ext%>><%=defaultValue.substr(0, 4)==0?'':LTrimCh(defaultValue.substr(0, 4)-1911, "0")%>年<input 
    type="hidden" class="<%=className%>" size="2" value="<%=LTrimCh(defaultValue.substr(5, 2), "0")%>" readonly <%=ext%>><%=LTrimCh(defaultValue.substr(5, 2), "0")%>月<input 
    type="hidden" class="<%=className%>" size="2" value="<%=LTrimCh(defaultValue.substr(8, 2), "0")%>" readonly <%=ext%>><%=LTrimCh(defaultValue.substr(8, 2), "0")%>日</font>
  <input type="hidden" name="<%=fieldName%>" id="<%=fieldName%>" value="<%=defaultValue%>">
<%
      }
/*
%>  民國<input class="<%=className%>" size="3" value="<%=defaultValue.substr(0, 4)==0?'':LTrimCh(defaultValue.substr(0, 4)-1911, "0")%>" readonly <%=ext%>>年<input 
    class="<%=className%>" size="2" value="<%=LTrimCh(defaultValue.substr(5, 2), "0")%>" readonly <%=ext%>>月<input 
    class="<%=className%>" size="2" value="<%=LTrimCh(defaultValue.substr(8, 2), "0")%>" readonly <%=ext%>>日
  <input type="hidden" name="<%=fieldName%>" id="<%=fieldName%>" value="<%=defaultValue%>">
<%
*/
    }
    else
    {
%>  <script language="javascript">
  <!--
  // 組合日期欄位資料
  
  <%=fieldName%>_fyear_value = '<%=defaultValue.substr(0, 4)==''?'':(1*defaultValue.substr(0, 4)-1911)%>';
  <%=fieldName%>_fmonth_value = '<%=defaultValue.substr(5, 2)%>';
  <%=fieldName%>_fday_value = '<%=defaultValue.substr(8, 2)%>';
  
  function Calc_<%=fieldName%>(fyear, fmonth, fday)
  {
    if (fyear != null)
    {
      <%=fieldName%>_fyear_value = fyear.value;
      if (<%=fieldName%>_fyear_value!='' && !CheckAllNumber(<%=fieldName%>_fyear_value))
      {
        <%=fieldName%>_fyear_value = '';
        window.alert('請您輸入數字錯誤.');
        fyear.value = '';
      }
    }
    
    if (fmonth != null)
    {
      <%=fieldName%>_fmonth_value = ''+fmonth.value;
      if (<%=fieldName%>_fmonth_value!='' && !CheckAllNumber(<%=fieldName%>_fmonth_value))
      {
        <%=fieldName%>_fmonth_value = '';
        window.alert('請您輸入數字錯誤.');
        fmonth.value = '';
      }
    }
    if (fday != null)
    {
      <%=fieldName%>_fday_value = ''+fday.value;
      if (<%=fieldName%>_fday_value!='' && !CheckAllNumber(<%=fieldName%>_fday_value))
      {
        <%=fieldName%>_fday_value = '';
        window.alert('請您輸入數字錯誤.');
        fday.value = '';
      }
    }
    
    if ((<%=fieldName%>_fyear_value != '') && (<%=fieldName%>_fmonth_value != '') && (<%=fieldName%>_fday_value != ''))
      document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value = LPad((1*<%=fieldName%>_fyear_value+1911), 4, '0') + '/' + LPad(<%=fieldName%>_fmonth_value, 2, '0') + '/' + LPad(<%=fieldName%>_fday_value, 2, '0');
    else
      document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value = '';

    if ((document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value != '') && !CheckDateStr(document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value))
      window.alert('日期資料錯誤.');
  }
  
  OnLoadHookCmd += " <%=fieldName%>_fyear_value = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_year.value; " + 
      " <%=fieldName%>_fmonth_value = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_month.value; " + 
      " <%=fieldName%>_fday_value = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_day.value; " + 
      " if ((<%=fieldName%>_fyear_value != '') && (<%=fieldName%>_fmonth_value != '') && (<%=fieldName%>_fday_value != '')) " +
      " document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value = LPad(<%=fieldName%>_fyear_value==''?'':(1*<%=fieldName%>_fyear_value+1911), 4, '0') + '/' + LPad(<%=fieldName%>_fmonth_value, 2, '0') + '/' + LPad(<%=fieldName%>_fday_value, 2, '0'); \n";
  //-->
  </script>
  民國<input class="<%=className%>" maxlength="3" name="_<%=fieldName%>_year" id="_<%=fieldName%>_year" size="3" onblur="Calc_<%=fieldName%>(this, null, null);" value="<%=defaultValue.substr(0, 4)==0?'':LTrimCh(defaultValue.substr(0, 4)-1911, "0")%>" <%=ext%>>年<input 
  class="<%=className%>" maxlength="2" name="_<%=fieldName%>_month" id="_<%=fieldName%>_month" size="2" onblur="Calc_<%=fieldName%>(null, this, null);" value="<%=LTrimCh(defaultValue.substr(5, 2), "0")%>" <%=ext%>>月<input 
  class="<%=className%>" maxlength="2" name="_<%=fieldName%>_day" id="_<%=fieldName%>_day" size="2" onblur="Calc_<%=fieldName%>(null, null, this);" value="<%=LTrimCh(defaultValue.substr(8, 2), "0")%>" <%=ext%>>日
  <!--input type="button" style="background-color: red; color: white; width=15; height=22;" onclick="var Ret=window.showModalDialog('show_calendar.asp');if (Ret != null) { document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_year.value=Ret.substr(1,2);Calc_<%=fieldName%>(document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_year, null, null);document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_month.value=Ret.substr(3,2);Calc_<%=fieldName%>(null, document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_month, null);document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_day.value=Ret.substr(5,2);Calc_<%=fieldName%>(null, null, document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_day);}"-->
  <input type="hidden" name="<%=fieldName%>" id="<%=fieldName%>" value="<%=defaultValue%>">
<%
    }
    
    Response.Write('\n<!-- ShowChDateEdit() End -->\n');
  }

  function ShowTimeEdit(fieldName, defaultValue, className, readonly, ext)
  {
    if (defaultValue == null)
      var defaultValue = "";
      
    defaultValue = '' + defaultValue;
      
    if (className == null)
      var className = "text";
    
    if (ext == null)
      var ext = '';
      
    var HourRID = 'f_hour_' + LPad(Math.round(Math.random() * 9999), 4, '0');
    var MinRID = 'f_min_' + LPad(Math.round(Math.random() * 9999), 4, 0);
    var SecRID = 'f_sec_' + LPad(Math.round(Math.random() * 9999), 4, 0);
    var DateFieldRID = 'f_time_' + LPad(Math.round(Math.random() * 9999), 4, 0);
      
    Response.Write('\n<!-- ShowTimeEdit() Begin -->\n');
    
    if (readonly == true)
    {
      if (IsNull(defaultValue))
      {
%><font class="readonlytext">[無]</font>
<%
      }
      else
      {
%>  <font class="readonlytext"><input type="hidden" class="<%=className%>" size="2" value="<%=defaultValue.substr(0, 2)%>" readonly <%=ext%>><%=defaultValue.substr(0, 2)%>:<input 
type="hidden" class="<%=className%>" size="2" value="<%=defaultValue.substr(3, 2)%>" readonly <%=ext%>><%=defaultValue.substr(3, 2)%>:<input 
type="hidden" class="<%=className%>" size="2" value="<%=defaultValue.substr(6, 2)%>" readonly <%=ext%>><%=defaultValue.substr(6, 2)%></font>
  <input type="hidden" name="<%=fieldName%>" id="<%=fieldName%>" value="<%=defaultValue%>">
<%
      }
/*
%>  <input class="<%=className%>" size="2" value="<%=defaultValue.substr(0, 2)%>" readonly <%=ext%>>:<input 
class="<%=className%>" size="2" value="<%=defaultValue.substr(3, 2)%>" readonly <%=ext%>>:<input 
class="<%=className%>" size="2" value="<%=defaultValue.substr(6, 2)%>" readonly <%=ext%>>
  <input type="hidden" name="<%=fieldName%>" id="<%=fieldName%>" value="<%=defaultValue%>">
<%
*/
    }
    else
    {
%>  <script language="javascript">
  <!--
  // 組合時間欄位資料
  function Calc_<%=fieldName%>()
  {
    var h = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>item('<%=HourRID%>').value;
    var m = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>item('<%=MinRID%>').value;
    var s = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>item('<%=SecRID%>').value;
    
    if ((h+m != '') && CheckAllNumber(h) && CheckAllNumber(m))
      document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>item('<%=DateFieldRID%>').value = LPad(h, 2, '0') + ':' + LPad(m, 2, '0') + ':' + LPad(s, 2, '0');
    else
      document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>item('<%=DateFieldRID%>').value = '';
  }
  //-->
  </script>
  <input class="<%=className%>" maxlength="2" id="<%=HourRID%>" name="_<%=fieldName%>_hour" size="2" onblur="Calc_<%=fieldName%>()" value="<%=defaultValue.substr(0, 2)=="00"?"0":LTrimCh(defaultValue.substr(0, 2), "0")%>" <%=ext%>>:<input 
  class="<%=className%>" maxlength="2" id="<%=MinRID%>" name="_<%=fieldName%>_min" size="2" onblur="Calc_<%=fieldName%>()" value="<%=defaultValue.substr(3, 2)=="00"?"0":LTrimCh(defaultValue.substr(3, 2), "0")%>" <%=ext%>>:<input 
  class="<%=className%>" maxlength="2" id="<%=SecRID%>" name="_<%=fieldName%>_min" size="2" onblur="Calc_<%=fieldName%>()" value="<%=defaultValue.substr(6, 2)=="00"?"0":LTrimCh(defaultValue.substr(6, 2), "0")%>" <%=ext%>>
  <input type="hidden" id="<%=DateFieldRID%>" name="<%=fieldName%>" value="<%=defaultValue%>">
<%
    }
    
    Response.Write('\n<!-- ShowTimeEdit() End -->\n');
  }
  
  function DownloadSQLCode(CodeKind, IDField, NameField, QueryStr)
  {
    var Qry = SQLExecute(QueryStr);


%>
<script language="javascript">
<!--
  var Code<%=CodeKind%> = <%
    Response.Write("'");
    for (var i=0; !Qry.eof; i++)
    {
      if (Qry(NameField) != null)
        Response.Write('<option value="' + Qry(IDField) + '">' + Qry(IDField) + '.' + Qry(NameField) + '\\n');
      else
        Response.Write('<option value="' + Qry(IDField) + '">' + Qry(IDField) + '\\n');
      Qry.moveNext;
    }
    Qry.Close();
    Qry = null;
    Response.Write("';");
%>
  function FindCode<%=CodeKind%>ID(IDStr)
  {
    if (IDStr == '')
      return "";
      
    var re = new RegExp('value="' + IDStr, '');
    var foundloc = Code<%=CodeKind%>.search(re);
    if (foundloc < 0)
      return "";

    foundloc+=7;
    for (var i=foundloc; i<Code<%=CodeKind%>.length; i++)
      if (Code<%=CodeKind%>.charAt(i) == '"')
        return Code<%=CodeKind%>.substr(foundloc, i-foundloc);

    return "";
  }
  function GetCode<%=CodeKind%>IDName(IDStr)
  {
    if (IDStr == '')
      return '[無]';
      
    var re = new RegExp('value="' + IDStr + '">', '');
    var foundloc = Code<%=CodeKind%>.search(re);
    if (foundloc < 0)
      return IDStr + '.';

    foundloc+=('value="' + IDStr + '">').length+1;
    for (var i=foundloc; i<Code<%=CodeKind%>.length; i++)
      if (Code<%=CodeKind%>.charAt(i) == '.')
      {
        foundloc = i+1;
        break;
      }
      
    for (var i=foundloc; i<Code<%=CodeKind%>.length; i++)
      if (Code<%=CodeKind%>.charAt(i) == '\n')
        return IDStr + '.' + Code<%=CodeKind%>.substr(foundloc, i-foundloc);

    return IDStr + '.';
  }
-->
</script>
<%
  }

  function ShowSavedCode(CodeKind, fieldName, selectedID, extEvent, allowUnSelect, className, readonly)
  {
    if (className == null)
      className = 'text';
      
    Response.Write('\n<!-- ShowSavedCode() Begin -->\n');
    
    var CodeContentStrs = new Array(0);
 
    for (var i=0, l=0, t=0; i<CodeKind.length; i++)
      if (CodeKind.charAt(i) == '+')
      {
        CodeContentStrs[t++] = CodeKind.substr(l, i-l);
        l = i+1;
      }
      else if (i==CodeKind.length-1)
        CodeContentStrs[t++] = CodeKind.substr(l, i-l+1);
    
    if (!readonly)
    {
%>
  <input type="text" class="<%=className%>" id="_<%=fieldName%>_extext" 
    onBlur="this.value=document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value; this.size=1; this.value=this.value.toUpperCase();" 
    onKeyUp="if (this.value.length > 0 && this.size<this.value.length) this.size=this.value.length; Found=''; FindKey=this.value.toUpperCase();
<%
  for (var i=0; i<CodeContentStrs.length; i++)
  {
%>if (Found=='') Found=window.parent.FindCode<%=CodeContentStrs[i]%>ID(FindKey); <%
  }
%>
      document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value=Found;"
    size=1 value="<%=selectedID%>">
<script language=JavaScript>
<!--
  document.write('<select id="<%=fieldName%>" name="<%=fieldName%>" class=<%=className%> onChange="_<%=fieldName%>_extext.value=this.value;" <%=extEvent%>>');
<%
  if (allowUnSelect)
  {
%>  document.write('<option value="">未選取</option>\n');
<%
  }

  for (var i=0; i<CodeContentStrs.length; i++)
  {
%>  document.write(window.parent.Code<%=CodeContentStrs[i]%>);
<%
  }
%>
  document.write('</select>');
  document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value='<%=selectedID%>';

  OnLoadHookCmd += ' if (document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_extext.value!="") document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value=document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>_<%=fieldName%>_extext.value; else document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%><%=fieldName%>.value=""; \n';
-->
</script>
<%
    }
    else
    {
%>    <input name="<%=fieldName%>" id="<%=fieldName%>" type="hidden" value="<%=selectedID%>"><input readonly value="<%=selectedID%>" class="<%=className%>" name="__<%=fieldName%>" id="__<%=fieldName%>" size="4" <%=extEvent%>>
<script language=JavaScript>
<!--
  var ShowCodeText = '';
<%
  for (var i=0; i<CodeContentStrs.length; i++)
  {
%>if (ShowCodeText=='') ShowCodeText=window.parent.GetCode<%=CodeContentStrs[i]%>IDName('<%=selectedID%>'); <%
  }
%>
  document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>__<%=fieldName%>.value = ShowCodeText;
  document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>__<%=fieldName%>.size = document.all.<%=!IsNull(CurrentFormName)?CurrentFormName+'.':''%>__<%=fieldName%>.value.length*2-2;
-->
</script>
<%
    }

    Response.Write('\n<!-- ShowSavedCode() End -->\n');
  }

  function ShowCustomSelect(dataArray, fieldName, selectedID, extEvent, allowUnSelect, className, readonly)
  {
    var SelectContent;
    
    if (className == null)
      className = 'text';
      
    Response.Write('\n<!-- ShowCustomSelect() Begin -->\n');
    
    if (!readonly)
    {
%>
  <input type="text" class="<%=className%>" id="_<%=fieldName%>_extext" 
    onBlur="this.value=this.value.toUpperCase(); this.size=1; this.value=this.value.toUpperCase();" 
    onKeyUp="if (this.value.length > 0 && this.size<this.value.length) this.size=this.value.length; 
        for (var i=0; i<<%=fieldName%>.options.length; i++) 
          if (<%=fieldName%>.options(i).value.substr(0, this.value.length).toUpperCase()==this.value.toUpperCase()) 
          { <%=fieldName%>.selectedIndex=i; return; }
        <%=fieldName%>.selectedIndex=-1;" 
    size=1 value="<%=selectedID%>"><select class="<%=className%>" name="<%=fieldName%>" id="<%=fieldName%>" 
    onClick="_<%=fieldName%>_extext.value=this.value;"
    <%=extEvent%>>
<%
    }
    
    if (allowUnSelect == null)
      allowUnSelect = false;
      
    if (!readonly && allowUnSelect)
      Response.Write('    <option value="">未選取</option>\n');
        
    if (selectedID == null)
      selectedID = '';
    else
      selectedID = ''+selectedID;

    for (var i=0; i<dataArray.length; i+=2)
    {
      if (readonly)
      {
        if (selectedID == ""+dataArray[i])
          SelectContent = "" + dataArray[i+1];
      }
      else
      {
        if (selectedID == ""+dataArray[i])
          Response.Write('    <option value="' + dataArray[i] + '" selected>' + dataArray[i+1] + '</option>\n');
        else
          Response.Write('    <option value="' + dataArray[i] + '">' + dataArray[i+1] + '</option>\n');
      }
    }

    if (IsNull(SelectContent))
    {
      if (IsNull(selectedID))
        SelectContent = '';
      else 
        SelectContent = selectedID + '.[無對應代碼]';
    }
      
    if (readonly)
    {
%>    <font class="readonlytext"><input name="<%=fieldName%>" id="<%=fieldName%>" type="hidden" value="<%=selectedID%>"><input readonly type="hidden" value="<%=SelectContent%>" class="<%=className%>" name="__<%=fieldName%>" id="__<%=fieldName%>" size="<%=SelectContent.length*2+2%>" <%=extEvent%>><%=IsNull(SelectContent)?"[無]":SelectContent%></font>
<%
/*
%>    <input name="<%=fieldName%>" id="<%=fieldName%>" type="hidden" value="<%=selectedID%>"><input readonly value="<%=SelectContent%>" class="<%=className%>" name="__<%=fieldName%>" id="__<%=fieldName%>" size="<%=SelectContent.length*2+2%>" <%=extEvent%>>
<%
*/
    }

    if (!readonly)
    {
%>  </select>  
<%
    }
    
    Response.Write('\n<!-- ShowCustomSelect() End -->\n');
  }

  function ShowSQLSelect(sql, id, content, fieldName, selectedID, extEvent, allowUnSelect, className, readonly)
  {
    var SelectContent;
    
    if (className == null)
      className = 'text';
      
    Response.Write('\n<!-- ShowSQLSelect() Begin -->\n');
    
    if (!readonly)
    {
%>
  <input type="text" class="<%=className%>" style="display: none;" id="_<%=fieldName%>_extext" 
    onBlur="this.value=this.value.toUpperCase(); this.size=1; this.value=this.value.toUpperCase();" 
    onKeyUp="if (this.value.length > 0 && this.size<this.value.length) this.size=this.value.length; 
        for (var i=0; i<<%=fieldName%>.options.length; i++) 
          if (<%=fieldName%>.options(i).value.substr(0, this.value.length).toUpperCase()==this.value.toUpperCase()) 
          { <%=fieldName%>.selectedIndex=i; return; }
        <%=fieldName%>.selectedIndex=-1;" 
    size=1 value="<%=selectedID%>"><select class="<%=className%>" name="<%=fieldName%>" id="<%=fieldName%>" 
    onClick="_<%=fieldName%>_extext.value=this.value;"
    <%=extEvent%>>
<%
    }
    
    var Qry = SQLExecute(sql);
        
    if (allowUnSelect == null)
      allowUnSelect = false;
      
    if (!readonly && allowUnSelect)
      Response.Write('    <option value="">未選取</option>\n');
        
    if (selectedID == null)
      selectedID = '';
    else
      selectedID = ''+selectedID;

    while (!Qry.Eof)
    {
      if (readonly)
      {
        if (selectedID == ""+Qry(id))
          SelectContent = "" + Qry(content);
      }
      else
      {
        if (selectedID == ""+Qry(id))
          Response.Write('    <option value="' + Qry(id) + '" selected>' + Qry(content) + '</option>\n');
        else
          Response.Write('    <option value="' + Qry(id) + '">' + Qry(content) + '</option>\n');
      }
      Qry.moveNext;
    }
    Qry.Close;
    Qry = null;

    if (IsNull(SelectContent))
    {
      if (IsNull(selectedID))
        SelectContent = '';
      else 
        SelectContent = selectedID + '.[無對應代碼]';
    }
      
    if (readonly)
    {
%>    <font class="readonlytext"><input name="<%=fieldName%>" id="<%=fieldName%>" type="hidden" value="<%=selectedID%>"><input readonly type="hidden" value="<%=SelectContent%>" class="<%=className%>" name="__<%=fieldName%>" id="__<%=fieldName%>" size="<%=SelectContent.length*2+2%>" <%=extEvent%>><%=IsNull(SelectContent)?"[無]":SelectContent%></font>
<%
/*
%>    <input name="<%=fieldName%>" id="<%=fieldName%>" type="hidden" value="<%=selectedID%>"><input readonly value="<%=SelectContent%>" class="<%=className%>" name="__<%=fieldName%>" id="__<%=fieldName%>" size="<%=SelectContent.length*2+2%>" <%=extEvent%>>
<%
*/
    }

    if (!readonly)
    {
%>  </select>  
<%
    }
    
    Response.Write('\n<!-- ShowSQLSelect() End -->\n');
  }

  function ShowCodeSelect(codeKind, fieldName, selectedID, extEvent, allowUnSelect, className, readonly)
  {
    ShowSQLSelect("select code_content , code_id from webap_code " + 
        "where code_kind = '" + codeKind + "' order by code_order, len(code_id), code_id", 
        "code_id", "code_content", fieldName, selectedID, extEvent, allowUnSelect, className, readonly);
  }
  
  function ShowBoolSelect(fieldName, defaultValue, extEvent, className, readonly)
  {
    if (className == null)
      className = 'text';
      
    Response.Write('\n<!-- ShowBoolSelect() Begin -->\n');
    
    if (''+defaultValue == 'Y')
      defaultValue = 'Y';
    else
      defaultValue = 'N';
      
    if (defaultValue == 'Y')
      var contenttext = "Y.是";
    else
      var contenttext = "N.否";
      
    if (readonly == true)
    {
%>      <font class="readonlytext"><input type="hidden" value="<%=defaultValue%>" name="<%=fieldName%>" id="<%=fieldName%>"><input readonly type="hidden" value="<%=contenttext%>" class="<%=className%>" name="__<%=fieldName%>" id="__<%=fieldName%>" size="4" <%=extEvent%>><%=IsNull(contenttext)?"[無]":contenttext%></font>
<%
/*
%>      <input type="hidden" value="<%=defaultValue%>" name="<%=fieldName%>" id="<%=fieldName%>"><input readonly value="<%=contenttext%>" class="<%=className%>" name="__<%=fieldName%>" id="__<%=fieldName%>" size="4" <%=extEvent%>>
<%
*/
    }
    else
    {
      if (defaultValue == 'Y')
      {
%>      <input type="checkbox" checked onClick="if (this.checked) {<%=fieldName%>_display.value='Y.是'; <%=fieldName%>.value='Y';} else {<%=fieldName%>_display.value='N.否'; <%=fieldName%>.value='N';}">
<%
      }
      else
      {
%>      <input type="checkbox" onClick="if (this.checked) {<%=fieldName%>_display.value='Y.是'; <%=fieldName%>.value='Y';} else {<%=fieldName%>_display.value='N.否'; <%=fieldName%>.value='N';}">
<%
      }
%><input type="hidden" value="<%=defaultValue%>" id="<%=fieldName%>" name="<%=fieldName%>" id="<%=fieldName%>"><input id="<%=fieldName%>_display" value="<%=contenttext%>" readonly class="<%=className%>" size="4" <%=extEvent%>>
<%
    }
    
    Response.Write('\n<!-- ShowBoolSelect() End -->\n');
  }
  
  function NameToFieldID(Name)
  {
    if (Name.substr(0, 2) == '__')
      return '__hex_' + StrToHex(Name.substr(2, 255));
    else if (Name.substr(0, 1) == '_')
      return '_hex_' + StrToHex(Name.substr(1, 255));
    else
      return 'hex_' + StrToHex(Name);
  }

  function FieldIDToName(FieldID)
  {
    if ((FieldID.substr(0, 4) == 'hex_') || (FieldID.substr(0, 5) == '_hex_') || (FieldID.substr(0, 6) == '__hex_'))
    {
      if (FieldID.substr(0, 2) == '__')
        return '__' + HexToStr(FieldID.substr(6, 255));
      else if (FieldID.substr(0, 1) == '_')
        return '_' + HexToStr(FieldID.substr(5, 255));
      else
        return HexToStr(FieldID.substr(4, 255));
    }
    else
      return FieldID; 
  }

  function CreateUI(postUrl, formName, defaultValueFromSav, defaultValueFromRcv, buttonArray, fieldsArray, trArray)
  {
    /*
      - text - 
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 顯示大小, 最大資料長度, 擴充);
          Ex: new Array('text', '收文文號:', 'acert_receive_doc_no', 'w', '', 30, 50, ''),
      - text_range - 
          ** 僅適用查詢
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 顯示大小, 最大資料長度, 擴充);
          Ex: new Array('text_range', '收文文號:', 'acert_receive_doc_no', 'w', '', 30, 50, ''),
      - passwd - 
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 顯示大小, 最大資料長度, 擴充);
          Ex: new Array('passwd', '收文文號:', 'acert_receive_doc_no', 'w', '', 30, 50, ''),
      - time -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 擴充);
          Ex: new Array('time', '收文日期:', 'acert_receive_doc_date', 'w', '', ''),
      - chdate -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 擴充);
          Ex: new Array('chdate', '收文日期:', 'acert_receive_doc_date', 'w', '', ''),
      - chdate_range -
          ** 僅適用查詢
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值1, 預設值2, 擴充);
          Ex: new Array('chdate_range', '收文日期:', 'acert_receive_doc_date', 'w', '', '', ''),
      - savedcode -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 代碼類別, 顯示[未選取], 擴充);
          Ex: new Array('savedcode', '性別:', 'acert_sex', 'rw', '', 'CodeD6', true, ''),
      - code -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 代碼類別, 顯示[未選取], 擴充);
          Ex: new Array('code', '性別:', 'acert_sex', 'rw', '', 'D6', true, ''),
      - sqlcombobox -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 參考欄位, 顯示欄位, sql指令, 顯示[未選取], 擴充);
          Ex: new Array('sqlcombobox', '使用者:', 'acert_sex', 'rw', '', 'user_id', 'user_name', 'select * from iam_user', true, ''),
      - customcombobox -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 資料陣列, 顯示[未選取], 擴充);
          Ex: new Array('customcombobox', '計量單位', '計量單位', 'rw', '', new Array('頁', '頁', '件', '件', '張', '張', '捲', '捲', '幅', '幅'), false, ''),
      - wordno - 
          Array(欄位型態, 欄位顯示名稱, 
              (年)欄位名稱, (年)預設值, (字)欄位名稱, (字)預設值, (號)欄位名稱, (號)預設值, 
              使用型態, 擴充);
          Ex: new Array('wordno', '考試院證書字號:', 'acert_ey_cer_wn_year', '', 
              'acert_ey_cer_wn_word', '', 'acert_ey_cer_wn_no', '', 'w', ''),
      - bool -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 擴充);
          Ex: new Array('bool', '共同執業人:', 'acert_pract_comm', 'r', Qry('acert_pract_comm'), ''),
      - textarea -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 高, 寬, 最大資料長度, 擴充);
          Ex: new Array('textarea', '收文文號:', 'acert_receive_doc_no', 'w', '', 10, 40, 2000, ''),
      - hidden -
          Array(欄位型態, 欄位名稱, 預設值, 擴充);
          Ex: new Array('hidden', 'acert_receive_doc_date', '', ''),
      - space -
          Array(欄位型態, 欄位顯示名稱);
          Ex: new Array('space', '代理人 開業資料'),
    */
    if ((fieldsArray != null) && (fieldsArray.length > 0))
    {
      Response.Write('\n<!-- CreateUI() Begin -->\n');
      CurrentFormName = formName;
      Response.Write('<form action="' + postUrl + '" id="' + formName + '" method="post" name="' + formName + '">');
      Response.Write('<table cellpadding=0 cellspacing=0 CLASS=uitable>\n');
      
      var IsTR = false;
      var IsNewLine = true;
      var Span = 1;
      
      for (var i=0; i<fieldsArray.length; i++)
        if ((fieldsArray[i] != null) && (fieldsArray[i].length > 0))
        {
          if (trArray == null || trArray.length < (i*2+1))
          {
            IsNewLine = true;
            Span = 1;
          }
          else
          {  
            if (trArray[i*2] != 'sameline')
              IsNewLine = true;
            else
              IsNewLine = false;
              
            Span = 1+(1*trArray[i*2+1]-1)*2;
            if (Span == 0)
              Span = 1;
          }

          if (fieldsArray[i][0] == 'text')
          {
            if (fieldsArray[i].length < 8)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "text"資料項必須為8個元素', '系統程式錯誤');
          
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            
            if (fieldsArray[i][1] == "公文文號:" || fieldsArray[i][1] == "收件編號:")
            {
              Response.Write('        <td nowrap class=header bgcolor=yellow><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
              Response.Write('        <td nowrap colspan=' + Span + ' class=editfield bgcolor=yellow>');
            }
            else
            {
              Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
              Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            }
            
            if (fieldsArray[i][3] == 'r')
              Response.Write('<font class="readonlytext">');
              
            Response.Write('<input name="' + NameToFieldID(fieldsArray[i][2]) + '" ');
            
            if (fieldsArray[i][3] == 'rw')
              Response.Write('class="text" ');
            else if (fieldsArray[i][3] == 'r')
              Response.Write('class="readonlytext" readonly type="hidden"');
            else if (fieldsArray[i][3] == 'w')
              Response.Write('class="requiretext" ');
              
            Response.Write('size="' + fieldsArray[i][5] + '" ');
            
            if (fieldsArray[i][3] != 'r')
              Response.Write('maxlength="' + fieldsArray[i][6] + '" ');
              
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
              
            if (defaultValue != '')
            {
              defaultValue = ReplaceStrAll(defaultValue, '"', '&quot;');
              Response.Write('value="' + defaultValue + '" ');
            }
              
            Response.Write(fieldsArray[i][7] + ' >');
            
            if (fieldsArray[i][3] == 'r')
            {
              defaultValue = ReplaceStrAll(defaultValue, '&', '&amp;');
              defaultValue = ReplaceStrAll(defaultValue, '<', '&lt;');
              defaultValue = ReplaceStrAll(defaultValue, '>', '&gt;');
              
              Response.Write(IsNull(defaultValue)?"[無]":defaultValue);
            }
              
            if (fieldsArray[i][3] == 'r')
              Response.Write('</font>');
              
            if (fieldsArray[i].length > 8)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          } 
          else if (fieldsArray[i][0] == 'text_range')
          {
            if (fieldsArray[i].length < 8)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "text_range"資料項必須為8個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            
            Response.Write('<input name="' + NameToFieldID(fieldsArray[i][2] + '__min') + '" ');
            
            if (fieldsArray[i][3] == 'rw')
              Response.Write('class="text" ');
            else if (fieldsArray[i][3] == 'r')
              Response.Write('class="readonlytext" readonly ');
            else if (fieldsArray[i][3] == 'w')
              Response.Write('class="requiretext" ');
              
            Response.Write('size="' + fieldsArray[i][5] + '" ');
            
            if (fieldsArray[i][3] != 'r')
              Response.Write('maxlength="' + fieldsArray[i][6] + '" ');
              
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
              
            if (defaultValue != '')
            {
              defaultValue = ReplaceStrAll(defaultValue, '"', '&quot;');
              Response.Write('value="' + defaultValue + '" ');
            }
              
            Response.Write(fieldsArray[i][7] + ' >');
            
            Response.Write(' ~ <input name="' + NameToFieldID(fieldsArray[i][2] + '__max') + '" ');
            
            if (fieldsArray[i][3] == 'rw')
              Response.Write('class="text" ');
            else if (fieldsArray[i][3] == 'r')
              Response.Write('class="readonlytext" readonly ');
            else if (fieldsArray[i][3] == 'w')
              Response.Write('class="requiretext" ');
              
            Response.Write('size="' + fieldsArray[i][5] + '" ');
            
            if (fieldsArray[i][3] != 'r')
              Response.Write('maxlength="' + fieldsArray[i][6] + '" ');
              
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
              
            if (defaultValue != '')
              Response.Write('value="' + defaultValue + '" ');
              
            Response.Write(fieldsArray[i][7] + ' >');
            
            if (fieldsArray[i].length > 8)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          } 
          else if (fieldsArray[i][0] == 'passwd')
          {
            if (fieldsArray[i].length < 8)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "text"資料項必須為8個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            
            Response.Write('<input type="password" name="' + NameToFieldID(fieldsArray[i][2]) + '" ');
            
            if (fieldsArray[i][3] == 'rw')
              Response.Write('class="text" ');
            else if (fieldsArray[i][3] == 'r')
              Response.Write('class="readonlytext" readonly ');
            else if (fieldsArray[i][3] == 'w')
              Response.Write('class="requiretext" ');
              
            Response.Write('size="' + fieldsArray[i][5] + '" ');
            
            if (fieldsArray[i][3] != 'r')
              Response.Write('maxlength="' + fieldsArray[i][6] + '" ');
              
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
              
            if (defaultValue != '')
            {
              defaultValue = ReplaceStrAll(defaultValue, '"', '&quot;');
              Response.Write('value="' + defaultValue + '" ');
            }
              
            Response.Write(fieldsArray[i][7] + ' >');
            
            if (fieldsArray[i].length > 8)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          } 
          else if (fieldsArray[i][0] == 'time')
          {
            if (fieldsArray[i].length < 6)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "time"資料項必須為6個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
            
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";
            
            ShowTimeEdit(NameToFieldID(fieldsArray[i][2]), defaultValue, className, (fieldsArray[i][3] == 'r'), fieldsArray[i][5])
            
            if (fieldsArray[i].length > 6)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          }
          else if (fieldsArray[i][0] == 'chdate')
          {
            if (fieldsArray[i].length < 6)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "chdate"資料項必須為6個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            
            if (fieldsArray[i][1] == "應辦結日期:")
            {
              Response.Write('        <td nowrap class=header bgcolor=#FF8000><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
              Response.Write('        <td nowrap colspan=' + Span + ' class=editfield bgcolor=#FF8000>');
            }
            else
            {
              Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
              Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            }
            
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
            
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";
            
            ShowChDateEdit(NameToFieldID(fieldsArray[i][2]), defaultValue, className, (fieldsArray[i][3] == 'r'), fieldsArray[i][5])
            
            if (fieldsArray[i].length > 6)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          }
          else if (fieldsArray[i][0] == 'chdate_range')
          {
            if (fieldsArray[i].length < 7)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "chdate"資料項必須為6個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            
            var defaultValue = fieldsArray[i][4];
            
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";
              

            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2] + '__min');
            }
              
            ShowChDateEdit(NameToFieldID(fieldsArray[i][2] + '__min'), defaultValue, className, (fieldsArray[i][3] == 'r'), fieldsArray[i][6]);

            Response.Write('至');

            var defaultValue = fieldsArray[i][5];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2] + '__max');
            }
            
            ShowChDateEdit(NameToFieldID(fieldsArray[i][2] + '__max'), defaultValue, className, (fieldsArray[i][3] == 'r'), fieldsArray[i][6]);
            
            if (fieldsArray[i].length > 7)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          }
          else if (fieldsArray[i][0] == 'time')
          {
            if (fieldsArray[i].length < 6)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "time"資料項必須為6個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
              
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";
              
            ShowTimeEdit(NameToFieldID(fieldsArray[i][2]), defaultValue, className, (fieldsArray[i][3] == 'r'), fieldsArray[i][5]);
            
            if (fieldsArray[i].length > 6)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          }
          else if (fieldsArray[i][0] == 'savedcode')
          {
            if (fieldsArray[i].length < 8)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "code"資料項必須為8個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
          
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
            
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";
              
            ShowSavedCode(fieldsArray[i][5], NameToFieldID(fieldsArray[i][2]), defaultValue, 
                fieldsArray[i][7], fieldsArray[i][6], className, (fieldsArray[i][3] == 'r'));
                
            if (fieldsArray[i].length > 8)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          }
          else if (fieldsArray[i][0] == 'code')
          {
            if (fieldsArray[i].length < 8)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "code"資料項必須為8個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
          
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
            
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";
              
            ShowCodeSelect(fieldsArray[i][5], NameToFieldID(fieldsArray[i][2]), defaultValue, 
                fieldsArray[i][7], fieldsArray[i][6], className, (fieldsArray[i][3] == 'r'));
                
            if (fieldsArray[i].length > 8)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          }
          else if (fieldsArray[i][0] == 'sqlcombobox')
          {
            if (fieldsArray[i].length < 10)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "sqlselect"資料項必須為10個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            
            if (fieldsArray[i][1] == "承辦人:")
            {
              Response.Write('        <td nowrap class=header bgcolor=#A0FFA0><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
              Response.Write('        <td nowrap colspan=' + Span + ' class=editfield bgcolor=#A0FFA0>');
            }
            else
            {
              Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
              Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            }
          
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
            
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";
              
            ShowSQLSelect(fieldsArray[i][7], fieldsArray[i][5], fieldsArray[i][6], NameToFieldID(fieldsArray[i][2]), defaultValue, 
                fieldsArray[i][9], fieldsArray[i][8], className, (fieldsArray[i][3] == 'r'));
                
            if (fieldsArray[i].length > 10)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          }
          else if (fieldsArray[i][0] == 'customcombobox')
          {
            if (fieldsArray[i].length < 8)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "customselect"資料項必須為8個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            
            if (fieldsArray[i][1] == "結案狀態:" || fieldsArray[i][1] == "處理狀態:")
            {
              Response.Write('        <td nowrap class=header bgcolor=#FFC000><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
              Response.Write('        <td nowrap colspan=' + Span + ' class=editfield bgcolor=#FFC000>');
            }
            else
            {
              Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
              Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            }
          
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
            
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";
              
            ShowCustomSelect(fieldsArray[i][5], NameToFieldID(fieldsArray[i][2]), defaultValue, 
                fieldsArray[i][7], fieldsArray[i][6], className, (fieldsArray[i][3] == 'r'));
                
            if (fieldsArray[i].length > 8)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          }
          else if (fieldsArray[i][0] == 'wordno')
          {
            if (fieldsArray[i].length < 10)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "wordno"資料項必須為10個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            
            Response.Write('(<input name="' + NameToFieldID(fieldsArray[i][2]) + '" ');
            
            if (fieldsArray[i][8] == 'rw')
              Response.Write('class="text" ');
            else if (fieldsArray[i][8] == 'r')
              Response.Write('class="readonlytext" readonly ');
            else if (fieldsArray[i][8] == 'w')
              Response.Write('class="requiretext" ');
              
            Response.Write('size="3" ');
            
            if (fieldsArray[i][8] != 'r')
              Response.Write('maxlength="3" ');
              
            var defaultValue = fieldsArray[i][3];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
              
            if (defaultValue != '')
              Response.Write('value="' + defaultValue + '" ');
              
            Response.Write(fieldsArray[i][9] + ' >)');


            Response.Write('<input name="' + fieldsArray[i][4] + '" ');
            
            if (fieldsArray[i][8] == 'rw')
              Response.Write('class="text" ');
            else if (fieldsArray[i][8] == 'r')
              Response.Write('class="readonlytext" readonly ');
            else if (fieldsArray[i][8] == 'w')
              Response.Write('class="requiretext" ');
              
            Response.Write('size="16" ');
            
            if (fieldsArray[i][8] != 'r')
              Response.Write('maxlength="16" ');
              
            var defaultValue = fieldsArray[i][5];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][4]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][4]);
            }
              
            if (defaultValue != '')
              Response.Write('value="' + defaultValue + '" ');
              
            Response.Write(fieldsArray[i][9] + ' >字');


            Response.Write('<input name="' + fieldsArray[i][6] + '" ');
            
            if (fieldsArray[i][8] == 'rw')
              Response.Write('class="text" ');
            else if (fieldsArray[i][8] == 'r')
              Response.Write('class="readonlytext" readonly ');
            else if (fieldsArray[i][8] == 'w')
              Response.Write('class="requiretext" ');
              
            Response.Write('size="7" ');
            
            if (fieldsArray[i][8] != 'r')
              Response.Write('maxlength="7" ');
              
            var defaultValue = fieldsArray[i][7];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][6]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][6]);
            }
              
            if (defaultValue != '')
              Response.Write('value="' + defaultValue + '" ');
              
            Response.Write(fieldsArray[i][9] + ' >號');
            
            if (fieldsArray[i].length > 10)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          } 
          else if (fieldsArray[i][0] == 'bool')
          {
            if (fieldsArray[i].length < 6)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "bool"資料項必須為6個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td nowrap colspan=' + Span + ' class=editfield>');
            
            var defaultValue = fieldsArray[i][4];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = Sav.Item(fieldsArray[i][2]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = Rcv.Item(fieldsArray[i][2]);
            }
              
            if (fieldsArray[i][3] == 'rw')
              className = "text";
            else if (fieldsArray[i][3] == 'r')
              className = "readonlytext";
            else if (fieldsArray[i][3] == 'w')
              className = "requiretext";

            ShowBoolSelect(NameToFieldID(fieldsArray[i][2]), defaultValue, fieldsArray[i][5], className, (fieldsArray[i][3] == 'r'));
            
            if (fieldsArray[i].length > 6)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          } 
          else if (fieldsArray[i][0] == 'textarea')
          {
            if (fieldsArray[i].length < 9)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "textarea"資料項必須為9個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap class=header><p class=label>' + fieldsArray[i][1] + '</p></td>\n');
            Response.Write('        <td colspan=' + Span + ' class=editfield width="600">');
            
            if (fieldsArray[i][3] == 'r')
            {
              Response.Write('<font class="readonlytext"><input name="' + NameToFieldID(fieldsArray[i][2]) + '" ');
              Response.Write('readonly type="hidden"');
                
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
                
              if (defaultValue != '')
              {
                defaultValue = ReplaceStrAll(defaultValue, '"', '&quot;');
                Response.Write(' value="' + defaultValue + '" ');
              }
                
              Response.Write(fieldsArray[i][8] + ' >');
              
              defaultValue = ReplaceStrAll(defaultValue, '&', '&amp;');
              defaultValue = ReplaceStrAll(defaultValue, '<', '&lt;');
              defaultValue = ReplaceStrAll(defaultValue, '>', '&gt;');
              defaultValue = ReplaceStrAll(defaultValue, '\n', '<br>');
              
              Response.Write(IsNull(defaultValue)?"[無]":defaultValue);
              Response.Write('</font>');
            }
            else
            {
              Response.Write('<textarea name="' + NameToFieldID(fieldsArray[i][2]) + '" ');
              
              if (fieldsArray[i][3] == 'rw')
                Response.Write('class="text" ');
              else if (fieldsArray[i][3] == 'r')
                Response.Write('class="readonlytext" readonly ');
              else if (fieldsArray[i][3] == 'w')
                Response.Write('class="requiretext" ');
                
              Response.Write('rows="' + fieldsArray[i][5] + '" ');
              Response.Write('cols="' + fieldsArray[i][6] + '" ');
              
              if (fieldsArray[i][3] != 'r')
                Response.Write('maxlength="' + fieldsArray[i][7] + '" ');
                
              Response.Write(fieldsArray[i][8] + ' >');
              
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
                
              if (defaultValue != '')
              {
                defaultValue = ReplaceStrAll(defaultValue, '"', '&quot;');
                Response.Write(defaultValue);
              }
                
              Response.Write('</textarea>');
            }
            
            if (fieldsArray[i].length > 9)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          } 
          else if (fieldsArray[i][0] == 'hidden')
          {
            if (fieldsArray[i].length < 4)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "hidden"資料項必須為4個元素', '系統程式錯誤');
              
            Response.Write('      <input type="hidden" name="' + NameToFieldID(fieldsArray[i][1]) + '" ');
            
            var defaultValue = fieldsArray[i][2];
            
            if (defaultValue == '')
            {
              if ((defaultValueFromSav == true) && (Sav != null))
                defaultValue = '' + Sav.Item(fieldsArray[i][1]);
              if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                defaultValue = '' + Rcv.Item(fieldsArray[i][1]);
            }
            
            if (defaultValue != '')
            {
              defaultValue = ReplaceStrAll(defaultValue, '"', '&quot;');
              Response.Write('value="' + defaultValue + '" ');
            }
              
            if (fieldsArray[i].length > 4)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write(fieldsArray[i][3] + ' >\n');
          } 
          else if (fieldsArray[i][0] == 'space')
          {
            if (fieldsArray[i].length < 2)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "space"資料項必須為2個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap colspan=' + (1*Span+1) + ' bgcolor="#4374B0" style="height: 25px;"><img src="./images/SpaceIcon.gif" align=left><p align="left"><font style="font: 12pt \'細明體\';""><b>' + fieldsArray[i][1] + '</b></font></p>');

            if (fieldsArray[i].length > 2)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          } 
          else if (fieldsArray[i][0] == 'spacehint')
          {
            if (fieldsArray[i].length < 2)
              DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "spacehint"資料項必須為2個元素', '系統程式錯誤');
              
            if (IsNewLine)
            {
              if (IsTR)
                Response.Write('      </tr>\n');
              Response.Write('      <tr>\n');
              IsTR = true;
            }
            Response.Write('        <td nowrap colspan=' + (1*Span+1) + ' bgcolor="#B0B0FF" style="height: 25px;" align=center><font style="font: 12pt \'細明體\';"><b><font color=white>◆</font> ' + fieldsArray[i][1] + ' <font color=white>◆</font></b></font>');

            if (fieldsArray[i].length > 2)
              Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
              
            Response.Write('</td>\n');
          } 
        }
        if (IsTR)
          Response.Write('</tr>\n');
      Response.Write('    </table>');
      if ((buttonArray != null) && (buttonArray.length > 0))
      {
        Response.Write('<span id=_btn>');
        for (var i=0; i<buttonArray.length; i+=2)
        {
          if (buttonArray[i] == 'submit')
            Response.Write('<input class="button" name="_action" type="submit" value="' + buttonArray[i+1] + '">');
          else if (buttonArray[i] == 'reset')
            Response.Write('<input class="button" type="reset" value="' + buttonArray[i+1] + '">');
          else 
            Response.Write('<input class="button" type="button" value="' + buttonArray[i+1] + '" onclick="' + buttonArray[i] + '">');
        }
        Response.Write('</span>');
      }
      Response.Write('</form>');
      Response.Write('<!-- CreateUI() End -->');
    }
  }


  function CreateUIArray(postUrl, formName, defaultValueFromSav, defaultValueFromRcv, buttonArray, fieldsArray, defaultValueQuery, checkFunc)
  {
    /*
      - text - 
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 顯示大小, 最大資料長度, 擴充);
          Ex: new Array('text', '收文文號:', 'acert_receive_doc_no', 'w', '', 30, 50, ''),
      - passwd - 
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 顯示大小, 最大資料長度, 擴充);
          Ex: new Array('passwd', '收文文號:', 'acert_receive_doc_no', 'w', '', 30, 50, ''),
      - chdate -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 擴充);
          Ex:  new Array('chdate', '收文日期:', 'acert_receive_doc_date', 'w', '', ''),
      - savedcode -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 代碼類別, 顯示[未選取], 擴充);
          Ex: new Array('savedcode', '性別:', 'acert_sex', 'rw', '', 'CodeD6', true, ''),
      - code -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 代碼類別, 顯示[未選取], 擴充);
          Ex: new Array('code', '性別:', 'acert_sex', 'rw', '', 'D6', true, ''),
      - sqlcombobox -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 參考欄位, 顯示欄位, sql指令, 顯示[未選取], 擴充);
          Ex: new Array('sqlcombobox', '使用者:', 'acert_sex', 'rw', '', 'user_id', 'user_name', 'select * from iam_user', true, ''),
      - wordno - 
          Array(欄位型態, 欄位顯示名稱, 
              (年)欄位名稱, (年)預設值, (字)欄位名稱, (字)預設值, (號)欄位名稱, (號)預設值, 
              使用型態, 擴充);
          Ex: new Array('wordno', '考試院證書字號:', 'acert_ey_cer_wn_year', '', 
              'acert_ey_cer_wn_word', '', 'acert_ey_cer_wn_no', '', 'w', ''),
      - bool -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 擴充);
          Ex: new Array('bool', '共同執業人:', 'acert_pract_comm', 'r', Qry('acert_pract_comm'), ''),
      - textarea -
          Array(欄位型態, 欄位顯示名稱, 欄位名稱, 使用型態, 預設值, 高, 寬, 最大資料長度, 擴充);
          Ex: new Array('textarea', '收文文號:', 'acert_receive_doc_no', 'w', '', 10, 40, 2000, ''),
      - hidden -
          Array(欄位型態, 欄位名稱, 預設值, 擴充);
          Ex: new Array('hidden', 'acert_receive_doc_date', '', ''),
    */
    if ((fieldsArray != null) && (fieldsArray.length > 0))
    {
      Response.Write('\n<!-- CreateUIArray() Begin -->\n');
      Response.Write('  <center>\n');
      
      CurrentFormName = formName;
      
      Response.Write('  <form action="' + postUrl + '" id="' + CurrentFormName + '" method="post" name="' + CurrentFormName + '">\n');
        
      Response.Write('    <table border="1" bordercolor="#BBBBFF" cellpadding="1" cellspacing="0">\n');
      
      Response.Write('      <tr>\n');
      for (var i=0; i<fieldsArray.length; i++)
        if (fieldsArray[i][0] != 'hidden')
          Response.Write('        <td nowrap><p align="center">' + fieldsArray[i][1] + '</p></td>\n');
      if (defaultValueQuery==null)
        Response.Write('        <td nowrap>&nbsp;</td>\n');
      Response.Write('      </tr>\n');
      
      for (var t=0; (t<MaxUIArrayCount) || (defaultValueQuery!=null); t++)
      {
        if (defaultValueQuery!=null)
          if (defaultValueQuery.Eof)
            break;

        ShowData = true;
        if (!IsNull(checkFunc))
          eval(checkFunc);
            
        if (!ShowData)
        {
          t--;
          defaultValueQuery.moveNext;
          continue;
        }
        
        if (defaultValueQuery!=null)
          Response.Write('      <tr id="DataRow' + t + '" >\n');
        else if (t>=1)
          Response.Write('      <tr id="DataRow' + t + '" style="display:none">\n');
        else
          Response.Write('      <tr id="DataRow' + t + '" >\n');
          
        for (var i=0; i<fieldsArray.length; i++)
          if ((fieldsArray[i] != null) && (fieldsArray[i].length > 0))
          {
            if (fieldsArray[i][0] == 'text')
            {
              if (fieldsArray[i].length < 8)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "text"資料項必須為8個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap align="center">');
              
              Response.Write('<input name="' + NameToFieldID(fieldsArray[i][2]) + t + '" ');
              
              if (fieldsArray[i][3] == 'rw')
                Response.Write('class="text" ');
              else if (fieldsArray[i][3] == 'r')
                Response.Write('class="readonlytext" readonly ');
              else if (fieldsArray[i][3] == 'w')
                Response.Write('class="requiretext" ');
                
              Response.Write('size="' + fieldsArray[i][5] + '" ');
              
              if (fieldsArray[i][3] != 'r')
                Response.Write('maxlength="' + fieldsArray[i][6] + '" ');
                
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
              
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);
                
              if (defaultValue != '')
                Response.Write('value="' + defaultValue + '" ');
                
              Response.Write(fieldsArray[i][7]);
//              if (defaultValueQuery==null)
//                Response.Write(' onblur="if (value!=\'\') DataRow'+(t+1)+'.style.display=\'\';"');
              Response.Write('>');
              
              if (fieldsArray[i].length > 8)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            } 
            else if (fieldsArray[i][0] == 'passwd')
            {
              if (fieldsArray[i].length < 8)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "text"資料項必須為8個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap align="center">');
              
              Response.Write('<input type="password" name="' + NameToFieldID(fieldsArray[i][2]) + t + '" ');
              
              if (fieldsArray[i][3] == 'rw')
                Response.Write('class="text" ');
              else if (fieldsArray[i][3] == 'r')
                Response.Write('class="readonlytext" readonly ');
              else if (fieldsArray[i][3] == 'w')
                Response.Write('class="requiretext" ');
                
              Response.Write('size="' + fieldsArray[i][5] + '" ');
              
              if (fieldsArray[i][3] != 'r')
                Response.Write('maxlength="' + fieldsArray[i][6] + '" ');
                
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
                
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (defaultValue != '')
                Response.Write('value="' + defaultValue + '" ');
                
              Response.Write(fieldsArray[i][7] + ' >');
              
              if (fieldsArray[i].length > 8)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            } 
            else if (fieldsArray[i][0] == 'chdate')
            {
              if (fieldsArray[i].length < 6)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "chdate"資料項必須為6個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap align="center">');
              
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
                
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (fieldsArray[i][3] == 'rw')
                className = "text";
              else if (fieldsArray[i][3] == 'r')
                className = "readonlytext";
              else if (fieldsArray[i][3] == 'w')
                className = "requiretext";
                
              ShowChDateEdit('' + NameToFieldID(fieldsArray[i][2]) + t, defaultValue, className, (fieldsArray[i][3] == 'r'), fieldsArray[i][5])
              
              if (fieldsArray[i].length > 6)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            }
            else if (fieldsArray[i][0] == 'savedcode')
            {
              if (fieldsArray[i].length < 8)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "code"資料項必須為8個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap align="center">');
            
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
              
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (fieldsArray[i][3] == 'rw')
                className = "text";
              else if (fieldsArray[i][3] == 'r')
                className = "readonlytext";
              else if (fieldsArray[i][3] == 'w')
                className = "requiretext";
                
                
              ShowSavedCode(fieldsArray[i][5], ''+NameToFieldID(fieldsArray[i][2])+t, defaultValue, 
                  fieldsArray[i][7], fieldsArray[i][6], className, (fieldsArray[i][3] == 'r'));
                  
              if (fieldsArray[i].length > 8)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            }
            else if (fieldsArray[i][0] == 'code')
            {
              if (fieldsArray[i].length < 8)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "code"資料項必須為8個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap align="center">');
            
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
              
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (fieldsArray[i][3] == 'rw')
                className = "text";
              else if (fieldsArray[i][3] == 'r')
                className = "readonlytext";
              else if (fieldsArray[i][3] == 'w')
                className = "requiretext";
                
              ShowCodeSelect(fieldsArray[i][5], ''+NameToFieldID(fieldsArray[i][2])+t, defaultValue, 
                  fieldsArray[i][7], fieldsArray[i][6], className, (fieldsArray[i][3] == 'r'));
                  
              if (fieldsArray[i].length > 8)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            }
            else if (fieldsArray[i][0] == 'sqlcombobox')
            {
              if (fieldsArray[i].length < 10)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "sqlselect"資料項必須為10個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap align="center">');
            
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
              
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (fieldsArray[i][3] == 'rw')
                className = "text";
              else if (fieldsArray[i][3] == 'r')
                className = "readonlytext";
              else if (fieldsArray[i][3] == 'w')
                className = "requiretext";
                
              ShowSQLSelect(fieldsArray[i][7], fieldsArray[i][5], fieldsArray[i][6], ''+NameToFieldID(fieldsArray[i][2])+t, defaultValue, 
                  fieldsArray[i][9], fieldsArray[i][8], className, (fieldsArray[i][3] == 'r'));
                  
              if (fieldsArray[i].length > 10)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            }
            else if (fieldsArray[i][0] == 'wordno')
            {
              if (fieldsArray[i].length < 10)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "wordno"資料項必須為10個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap align="center">');
              
              Response.Write('(<input name="' + NameToFieldID(fieldsArray[i][2]) + '" ');
              
              if (fieldsArray[i][8] == 'rw')
                Response.Write('class="text" ');
              else if (fieldsArray[i][8] == 'r')
                Response.Write('class="readonlytext" readonly ');
              else if (fieldsArray[i][8] == 'w')
                Response.Write('class="requiretext" ');
                
              Response.Write('size="3" ');
              
              if (fieldsArray[i][8] != 'r')
                Response.Write('maxlength="3" ');
                
              var defaultValue = fieldsArray[i][3];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
                
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (defaultValue != '')
                Response.Write('value="' + defaultValue + '" ');
                
              Response.Write(fieldsArray[i][9] + ' >)');
  
  
              Response.Write('<input name="' + fieldsArray[i][4] + '" ');
              
              if (fieldsArray[i][8] == 'rw')
                Response.Write('class="text" ');
              else if (fieldsArray[i][8] == 'r')
                Response.Write('class="readonlytext" readonly ');
              else if (fieldsArray[i][8] == 'w')
                Response.Write('class="requiretext" ');
                
              Response.Write('size="16" ');
              
              if (fieldsArray[i][8] != 'r')
                Response.Write('maxlength="16" ');
                
              var defaultValue = fieldsArray[i][5];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][4]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][4]);
              }
                
              if (defaultValueQuery!=null)
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (defaultValue != '')
                Response.Write('value="' + defaultValue + '" ');
                
              Response.Write(fieldsArray[i][9] + ' >字');
  
  
              Response.Write('<input name="' + fieldsArray[i][6] + '" ');
              
              if (fieldsArray[i][8] == 'rw')
                Response.Write('class="text" ');
              else if (fieldsArray[i][8] == 'r')
                Response.Write('class="readonlytext" readonly ');
              else if (fieldsArray[i][8] == 'w')
                Response.Write('class="requiretext" ');
                
              Response.Write('size="7" ');
              
              if (fieldsArray[i][8] != 'r')
                Response.Write('maxlength="7" ');
                
              var defaultValue = fieldsArray[i][7];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][6]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][6]);
              }
                
              if (defaultValueQuery!=null)
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (defaultValue != '')
                Response.Write('value="' + defaultValue + '" ');
                
              Response.Write(fieldsArray[i][9] + ' >號');
              
              if (fieldsArray[i].length > 10)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            } 
            else if (fieldsArray[i][0] == 'bool')
            {
              if (fieldsArray[i].length < 6)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "bool"資料項必須為6個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap align="center">');
              
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
                
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (fieldsArray[i][3] == 'rw')
                className = "text";
              else if (fieldsArray[i][3] == 'r')
                className = "readonlytext";
              else if (fieldsArray[i][3] == 'w')
                className = "requiretext";
  
              ShowBoolSelect(''+NameToFieldID(fieldsArray[i][2])+t, defaultValue, fieldsArray[i][5], className, (fieldsArray[i][3] == 'r'));
              
              if (fieldsArray[i].length > 6)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            } 
            else if (fieldsArray[i][0] == 'textarea')
            {
              if (fieldsArray[i].length < 9)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "textarea"資料項必須為9個元素', '系統程式錯誤');
                
              Response.Write('        <td nowrap class=editfield>');
              
              Response.Write('<textarea name="' + NameToFieldID(fieldsArray[i][2]) + '" ');
              
              if (fieldsArray[i][3] == 'rw')
                Response.Write('class="text" ');
              else if (fieldsArray[i][3] == 'r')
                Response.Write('class="readonlytext" readonly ');
              else if (fieldsArray[i][3] == 'w')
                Response.Write('class="requiretext" ');
                
              Response.Write('rows="' + fieldsArray[i][5] + '" ');
              Response.Write('cols="' + fieldsArray[i][6] + '" ');
              
              if (fieldsArray[i][3] != 'r')
                Response.Write('maxlength="' + fieldsArray[i][7] + '" ');
                
              Response.Write(fieldsArray[i][8] + ' >');
              
              var defaultValue = fieldsArray[i][4];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = Sav.Item(fieldsArray[i][2]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = Rcv.Item(fieldsArray[i][2]);
              }
                
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][2]);

              if (defaultValue != '')
                Response.Write(defaultValue);
                
              Response.Write('</textarea>');
              
              if (fieldsArray[i].length > 9)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write('</td>\n');
            } 
            else if (fieldsArray[i][0] == 'hidden')
            {
              if (fieldsArray[i].length < 4)
                DebugMsg('_htmlmod.asp->CreateUI()作業錯誤: "hidden"資料項必須為4個元素', '系統程式錯誤');
                
              Response.Write('      <input type="hidden" name="' + NameToFieldID(fieldsArray[i][1])+t + '" ');
              
              var defaultValue = fieldsArray[i][2];
              
              if (defaultValue == '')
              {
                if ((defaultValueFromSav == true) && (Sav != null))
                  defaultValue = '' + Sav.Item(fieldsArray[i][1]);
                if ((defaultValueFromRcv == true) && IsNull(defaultValue))
                  defaultValue = '' + Rcv.Item(fieldsArray[i][1]);
              }
              
              if ((defaultValueQuery!=null) && (fieldsArray[i][2].charAt(0) != '_'))
                defaultValue = defaultValueQuery(fieldsArray[i][1]);

              if (defaultValue != '')
                Response.Write('value="' + defaultValue + '" ');
                
              if (fieldsArray[i].length > 4)
                Response.Write(fieldsArray[i][fieldsArray[i].length-1]);
                
              Response.Write(fieldsArray[i][3] + ' >\n');
            } 
          }
%>
        <input id="_hasrowdata<%=t%>" name="_hasrowdata<%=t%>" type=hidden value="<%=(defaultValueQuery!=null?'yes':(t>0?'no':'yes'))%>">
<%
        if (defaultValueQuery==null)
        {
%>
        <script language="javascript">
        <!--
          OnLoadHookCmd += " if (document.all._hasrowdata<%=t%>.value=='yes') { document.all.DataRow<%=t%>.style.display=''; <%=(t>0?"document.all.RowBtn" + (t-1) + ".value='取消';":"")%> } else { document.all.DataRow<%=t%>.style.display='none'; } \n";
        //--> 
        </script>
<%
        }

        if (defaultValueQuery==null)
          if (t<MaxUIArrayCount-1)
          {
%>
          <td><input id="RowBtn<%=t%>" type=button class="rowbutton" value="下一筆" 
              onclick="if (this.value=='下一筆') { DataRow<%=t+1%>.style.display=''; _hasrowdata<%=t+1%>.value='yes'; this.value='刪除'; } else if (this.value=='刪除') { DataRow<%=t%>.style.display='none'; _hasrowdata<%=t%>.value='no'; } "></td>
<%
          }
          else
            Response.Write('        <td nowrap>&nbsp;</td>\n');
        
        Response.Write('      </tr>\n');

        if (defaultValueQuery!=null)
          defaultValueQuery.MoveNext;
      }
      
      Response.Write('    </table></center>\n');
      
      if ((buttonArray != null) && (buttonArray.length > 0))
      {
        Response.Write('    <p align="center" id=_btn>');
        for (var i=0; i<buttonArray.length; i+=2)
        {
          if (buttonArray[i] == 'submit')
            Response.Write('<input class="button" name="_action" type="submit" value="' + buttonArray[i+1] + '">');
          else if (buttonArray[i] == 'reset')
            Response.Write('<input class="button" type="reset" value="' + buttonArray[i+1] + '">');
          else 
            Response.Write('<input class="button" type="button" value="' + buttonArray[i+1] + '" onclick="' + buttonArray[i] + '">');
          if ((i-1) % 3 == 0)
            Response.Write('<br>');
        }
        Response.Write('</p>\n');
      }
%>
<script language="javascript">
<!--
  if (window.name == '_print')
    _btn.style.display = "none";
//--> 
</script>
<%
      Response.Write('  </form>\n');
      Response.Write('<!-- CreateUIArray() End -->\n');
    }
  }
%>
