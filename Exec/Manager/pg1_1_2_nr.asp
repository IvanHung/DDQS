<%@  Language=JavaScript %>

<!--#include file="_define.asp" -->
<!--#include file="_chkfunc.asp" -->
<!--#include file="_common.asp" -->
<!--#include file="_dbctrl.asp" -->
<!--#include file="_htmlmod.asp" -->
<!--#include file="_filectrl.asp" -->
<!--#include file="_xmlctrl.asp" -->
<!--#include file="_menu.asp" -->
<!--#include file="_ap_functions.asp" -->

<%
  var ReqSize = Request.TotalBytes;
  var ReqBin = Request.BinaryRead(ReqSize);

  var FileObj = Server.CreateObject("basp21");
  
  var FileName = ExtractFileName(FileObj.FormFileName(ReqBin, "word_file"));

  if (FileObj.FormSaveAs(ReqBin, "word_file", ToRealFilePath("/") + "\\FileStore\\" + FileName) <= 0)
  {
    ErrorMsg('Word轉檔失敗[檔案名稱:' + FileName + '].',
        new Array('重新執行轉檔', "location.href='pg1_1_2_n.asp'", '回首頁', "location.href='pg1_1_2.asp'"));
  }

  Response.Redirect('pg1_1_2_d.asp?file_name=' + Server.URLEncode(FileName));

%>