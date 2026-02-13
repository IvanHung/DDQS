<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  HtmlHeader('查詢日曆');
%>
<html>
<script language='javascript' src='_chkfunc.js'></script>
<script language="javascript">
<!--
  function GetDateStr(Y, M, D)
  {
    return LPad(Y, 3, '0') + LPad(M, 2, '0') + LPad(D, 2, '0');
  }

  function IsValidDate(Y, M, D)
  {
    var datestr = GetDateStr(Y, M, D);
    
<%
/*  var Qry = SQLExecute("select hday_date from tfa_hday order by hday_date");
  
  while (!Qry.Eof)
  {
    Response.Write("    if (datestr == '" + Qry('hday_date') + "') return false;\n");
    Qry.moveNext;
  }
  Qry.Close;
  Qry = null;*/
%>
    return true;
  }
-->
</script>
<style>
.caldate
{
  background-color:#cfcf00;
  color: black;
  font-family: 細明體;
  font-size: 11pt;
  border-top: 1px solid #ffffff;
  border-left: 1px solid #ffffff;
  border-right: 1px solid #000000;
  border-bottom: 1px solid #000000;
  margin: 1pt;
  height: 14pt;
  width: 30pt;
  cursor: hand
}
</style>
<body>

<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%">
<script language="javascript">
<!--
  var TimeObj = new Date();
  var TodayTimeObj = new Date(TimeObj.getYear(), TimeObj.getMonth(), TimeObj.getDate());
  var CurTimeObj = new Date(TimeObj.getYear(), 0, 1);
  var EndTimeObj = new Date(TimeObj.getYear()+1, 11, 31);
  
  m = 0;
  IsToday = false;
  
  while (CurTimeObj <= EndTimeObj)
  {
    if (m != CurTimeObj.getMonth() + 1)
    {
      if (m != 0)
      {
        if (CurTimeObj.getDay() > 0)
          for (var i=CurTimeObj.getDay(); i<7; i++)
            document.write('<td align=center valign=center>&nbsp;</td>');
        document.write('</tr></table>');
        document.write('</td></tr>');
      }
      m = CurTimeObj.getMonth() + 1;
      document.write('<tr><td align=center valign=center>');
      document.write('<table cellpadding="0" cellspacing="4" border="0" width="80%" height="240">');
      document.write('<tr bgcolor=#000080><td align=center valign=center colspan=7><font color=white><b>' + (CurTimeObj.getYear()-1911) + '年' + (CurTimeObj.getMonth()+1) + '月</b></font></td></tr>');
      document.write('<tr><td align=center valign=center>日</td><td align=center valign=center>一</td><td align=center valign=center>二</td><td align=center valign=center>三</td><td align=center valign=center>四</td><td align=center valign=center>五</td><td align=center valign=center>六</td></tr>');
      document.write('<tr>');
      for (var i=0; i<CurTimeObj.getDay(); i++)
        document.write('<td align=center valign=center>&nbsp;</td>');
    }
    if (''+TodayTimeObj == ''+CurTimeObj)
    {
      if (!IsValidDate(CurTimeObj.getYear()-1911, CurTimeObj.getMonth()+1, CurTimeObj.getDate()))
        document.write('<td align=center valign=center><input type=button style="background-color:red" class=caldate disabled onclick="javascript:window.returnValue=GetDateStr(' + (CurTimeObj.getYear()-1911) + ', ' + (CurTimeObj.getMonth()+1) + ', ' + CurTimeObj.getDate() + ');window.close();" id="today" value="' + CurTimeObj.getDate() + '"></td>');
      else
        document.write('<td align=center valign=center><input type=button style="background-color:red" class=caldate onclick="javascript:window.returnValue=GetDateStr(' + (CurTimeObj.getYear()-1911) + ', ' + (CurTimeObj.getMonth()+1) + ', ' + CurTimeObj.getDate() + ');window.close();" id="today" value="' + CurTimeObj.getDate() + '"></td>');
    }
    else if (!IsValidDate(CurTimeObj.getYear()-1911, CurTimeObj.getMonth()+1, CurTimeObj.getDate()))
      document.write('<td align=center valign=center><input type=button style="background-color:#505050; color:white; cursor:default;" class=caldate disabled onclick="javascript:window.returnValue=GetDateStr(' + (CurTimeObj.getYear()-1911) + ', ' + (CurTimeObj.getMonth()+1) + ', ' + CurTimeObj.getDate() + ');window.close();" value="' + CurTimeObj.getDate() + '"></td>');
    else 
    {
      if (IsToday)
      {
        if (CurTimeObj.getDay() == 6 || CurTimeObj.getDay() == 0)
          document.write('<td align=center valign=center><input type=button style="background-color:#efaf00" class=caldate onclick="javascript:window.returnValue=GetDateStr(' + (CurTimeObj.getYear()-1911) + ', ' + (CurTimeObj.getMonth()+1) + ', ' + CurTimeObj.getDate() + ');window.close();" value="' + CurTimeObj.getDate() + '" id="validday"></td>');
        else
          document.write('<td align=center valign=center><input type=button style="background-color:#cfcf00" class=caldate onclick="javascript:window.returnValue=GetDateStr(' + (CurTimeObj.getYear()-1911) + ', ' + (CurTimeObj.getMonth()+1) + ', ' + CurTimeObj.getDate() + ');window.close();" value="' + CurTimeObj.getDate() + '" id="validday"></td>');
        IsToday = false;
      }
      else
      {
        if (CurTimeObj.getDay() == 6 || CurTimeObj.getDay() == 0)
          document.write('<td align=center valign=center><input type=button style="background-color:#efaf00" class=caldate onclick="javascript:window.returnValue=GetDateStr(' + (CurTimeObj.getYear()-1911) + ', ' + (CurTimeObj.getMonth()+1) + ', ' + CurTimeObj.getDate() + ');window.close();" value="' + CurTimeObj.getDate() + '"></td>');
        else
          document.write('<td align=center valign=center><input type=button style="background-color:#cfcf00" class=caldate onclick="javascript:window.returnValue=GetDateStr(' + (CurTimeObj.getYear()-1911) + ', ' + (CurTimeObj.getMonth()+1) + ', ' + CurTimeObj.getDate() + ');window.close();" value="' + CurTimeObj.getDate() + '"></td>');
      }
    }
      
    if (CurTimeObj.getDay() == 6)
      document.write('</tr><tr>');
    
    CurTimeObj.setDate(CurTimeObj.getDate()+1);
  }
  
  if (CurTimeObj.getDay() > 0)
    for (var i=CurTimeObj.getDay(); i<7; i++)
      document.write('<td align=center valign=center>&nbsp;</td>');
  document.write('</tr></table>');
  document.write('</td></tr>');
-->
</script>
</table>

<script language="javascript">
<!--
  if (!document.all.today.disabled)
    document.all.today.focus();
  else if (document.all.validday != null)
    document.all.validday.focus();
  window.scroll(1, TodayTimeObj.getMonth()*240);
-->
</script>

</body>

</html>

