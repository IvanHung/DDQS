<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  HtmlHeader('使用說明');
%>
<html>
<body>
<table border="0" class=pagetable cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td align=center>
    <table border=0 cellpadding=2 cellspacing=0 align=center>
      <tr>
        <td align=left bgcolor=#202080 height=40 style="border-style:solid; border-width:1; border-color:white blue blue white;"><font style="color: white; font: 18pt "細明體";"><b>通用輸入畫面操作說明</b></font></td>
      </tr>
      <tr>
        <td align=left bgcolor=white>
<p>於輸入畫面中, 您可看到許多的輸入欄位, 您必須輸入符合於該資料畫面規定條件的資料, 方可完成輸入作業.<p>
<p>系統將會於當您按下執行鈕時, 自動進行資料檢核, 如果資料的條件不符合於您所選擇欲執行的作業, 則系統將會以警告訊息提示您, 請您務必確認每一筆作業執行後的結果, 並依照提示完成輸入作業.<p>
<p>輸入資料的欄位有相當多種, 各有其不同的功能與使用方式, 列舉各欄位的說明如下:</p>

<table border="1" cellpadding="1" cellspacing="1" height="100%" width="100%">
<tr bgcolor=#a0a0ff><td>A.</td><td colspan=2>一般文數字輸入欄位:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp001.gif"></td>
<td><font color=#0000ff>本欄位僅可輸入文字或數字資料為主, 輸入之資料必須符合該頁面的輸入條件.</font></td></tr>
<tr bgcolor=#a0a0ff><td>B.</td><td colspan=2>日期資料欄位:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp002.gif"></td>
<td><font color=#0000ff>本欄位以輸入日期資料為主, 日期資料必須輸入符合於正確日期格式的資料, 否則將會提示更正訊息以要求更正.</font></td></tr>
<tr bgcolor=#a0a0ff><td>C.</td><td colspan=2>代碼資料欄位:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp003.gif"></td>
<td><font color=#0000ff>本欄位以輸入代碼資料為主, 您可按下右邊之按鈕, 將會顯示可輸入之代碼與對應代碼名稱, 您所輸入之代碼必須在可輸入代碼之中.</font></td></tr>
<tr bgcolor=#a0a0ff><td>D.</td><td colspan=2>是否資料欄位:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp004.gif"></td>
<td><font color=#0000ff>本欄位以輸入是否條件資料, 若是有勾選本項, 則本資料標示為"是", 不勾選則標示為"否".</font></td></tr>
<tr bgcolor=#a0a0ff><td>E.</td><td colspan=2>執行鈕:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp005.gif"></td>
<td><font color=#0000ff>此為無法輸入資料的執行鈕, 您可以選擇您要執行的作業, 按鈕後以執行作業.</font></td></tr>
</table>

<br>
    <table border=0 cellpadding=2 cellspacing=0 align=center>
      <tr>
        <td align=left bgcolor=#202080 height=40 style="border-style:solid; border-width:1; border-color:white blue blue white;"><font style="color: white; font: 18pt "細明體";"><b>通用查詢畫面操作說明</b></font></td>
      </tr>
      <tr>
        <td align=left bgcolor=white>
<p>於查詢條件輸入畫面中, 您可看到一個以上的查詢條件欄位, 您可輸入多個欲查詢範圍的條件.<p>
<p>如果<font color=#ff0000>您沒有輸入任何條件, 則查詢出所有的資料</font>, 如果<font color=#ff0000>您輸入的條件越多, 則查詢所得的資料越少</font>, 您可以藉由增加條件, 而逐漸篩選出您想要的資料.</p>
<p>查詢條件的欄位有相當多種, 各有其不同的功能與使用方式, 列舉各欄位的說明如下:</p>

<table border="1" cellpadding="1" cellspacing="1" height="100%" width="100%">
<tr bgcolor=#a0a0ff><td>A.</td><td colspan=2>一般文數字查詢欄位:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp001.gif"></td>
<td><font color=#0000ff>本欄位以查詢文字或數字資料為主, 當有輸入條件資料於本欄位時, 則查詢出之相似於本欄位之各筆資料.<br>
例如: <br>
輸入"明", 則可查出"李明依"、"陳明真"與"陳明"等.<br><br>
或是<b>您可於本欄位輸入"*"號, 以查詢相類似的資料</b>.<br>
例如: <br>
1.輸入"陳*", 則可查出"陳群和"、"陳柏芝"、"陳明真"、"陳明"、"陳美鳳"、"陳純真"與"陳曉東"等<br>
2.輸入"*真", 則可查出"陳明真"與"陳純真"等<br>
3.輸入"陳明*", 則可查出"陳明真"與"陳明"等<br>
4.輸入"陳*和", 則可查出"陳群和"等<br>
5.輸入"*明*", 則可查出"李明依"、"陳明真"與"陳明"等<br><br>
如果您要查詢完全相等於查詢條件之資料, 可以於查詢條件後加上一個"!", 則查詢出之資料之該欄將與查詢條件完全相同.<br>
例如: <br>
輸入"陳明!", 則僅可查出"陳明"一筆資料.</font></td></tr>
<tr bgcolor=#a0a0ff><td>B.</td><td colspan=2>日期查詢欄位:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp002.gif"></td>
<td><font color=#0000ff>本欄位以查詢日期資料為主, 當有輸入條件資料於本欄位時, 則查詢出之各筆資料之本欄位將完全相等於輸入條件.</font></td></tr>
<tr bgcolor=#a0a0ff><td>C.</td><td colspan=2>代碼查詢欄位:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp003.gif"></td>
<td><font color=#0000ff>本欄位以查詢代碼資料為主, 您可按下右邊之按鈕, 將會顯示可輸入之代碼與對應代碼名稱, 您所輸入之代碼必須在可輸入代碼之中, 當有輸入條件資料於本欄位時, 則查詢出之各筆資料之本欄位將完全相等於輸入條件.</font></td></tr>
<tr bgcolor=#a0a0ff><td>D.</td><td colspan=2>是否查詢欄位:</td></tr>
<tr><td></td><td align=right valign=top bgcolor=#EFEFFF><img src="./images/WebHelp004.gif"></td>
<td><font color=#0000ff>本欄位以查詢是否條件資料, 若是有勾選本項, 則查詢本項為"是"的資料.</font></td></tr>
</table>
<br>
        </td>
      </td>
    </table>
    </td>
  </tr>
  <tr>
    <td align=center>
      <input class="button" type="button" value="回上一頁" onClick="history.go(-1);">
    </td>
  </tr>
</table>

</body>

</html>

