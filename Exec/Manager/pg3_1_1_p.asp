<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('行政訴訟裁判書-資料查詢-列印');

  var Sav = new QrySave();

  if (Rcv.Item('rowguid') != '')
  {
    Sav.Exec("select * from DDQS_DOC where rowguid = '" + Rcv.Item('rowguid') + "'");

    Sav.SetItem('INDEX1_idx_nm', GetSelectText("select INDEX1 from DDQS_INDEX1 where rowguid='" + Sav.Item('INDEX1_idx') + "'"));

    DOC = Sav.Item('DOC');

    DOC = ReplaceStrAll(DOC, '<br>\n', '\n');
    DOC = ReplaceStrAll(DOC, '<br>', '\n');
    DOC = ReplaceStrAll(DOC, '\n\n', '\n');
    DOC = ReplaceStrAll(DOC, '\n', '<br><br>\n');
  }
%>
<script language="javascript">
<!--
  function DoPrint()
  {
    if (!window.confirm("本報表即將執行列印作業, 請問您要執行列印作業嗎?\n\n\n" +
        "★如果您選擇[確定], 將會開啟[列印對話盒].\n\n" +
        "　註:  請於等一下出現的[列印對話盒]中, \n     設定使用[直式](Protrait)列表, \n     於設定後再按[列印]鈕將執行列印工作.\n\n\n" +
        "★如果您選擇[取消], 則本報表畫面將會繼續保留.\n\n" +
        "　註:  之後, 您若要回到上一操作畫面, 請按下瀏覽器功能列上的[上一頁]按鈕."))
      return;

    window.print();
    history.go(-1);
  }
//-->
</script>
<body onload="DoPrint();">

<table border=0 width="100%" height="100%">
<tr><td align=center valign=center><table class="printtable_Protrait" border="0" cellspacing="0" cellpadding="0" width="98%" height="98%">
  <tr height="20">
    <td width="10%" style="border-style: solid; border-width: 1; border-color: black black black black;"><div align=center><font style="font: 20pt;"><b>行 政 訴 訟 裁 判 書 </b></font></div></td>
  </td>
  <tr height="20">
    <td width="10%"><br>文　　號: <%=IsNull(Sav.Item('DOCNO'))?'&nbsp;':Sav.Item('DOCNO')%><br>
    統一編號: <%=IsNull(Sav.Item('IDNO'))?'&nbsp;':Sav.Item('IDNO')%><br>
    發文日期: <%=IsNull(Sav.Item('SEND_DATE'))?'&nbsp;':Sav.Item('SEND_DATE')%><br>
    稅　　目: <%=IsNull(Sav.Item('INDEX1_idx'))?'&nbsp;':Sav.Item('INDEX1_idx_nm')%><br>
    行政訴訟項目: <%=IsNull(Sav.Item('INDEX2_LIST'))?'&nbsp;':Sav.Item('INDEX2_LIST')%><br>
    關 鍵 字: <%=IsNull(Sav.Item('KEY_LIST'))?'&nbsp;':Sav.Item('KEY_LIST')%><br>
    <hr size=0>
    內　　容: <br><br><%=DOC%><br><hr size=0><div align=center>&lt;文件結尾&gt;</div></td>
  </tr>
</table></td></tr></table>

</body>

</html>
