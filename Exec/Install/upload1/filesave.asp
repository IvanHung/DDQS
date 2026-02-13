<HTML><HEAD><TITLE>檔案上傳</TITLE>
<BODY>
<%
'底下三行固定，一定要寫
a=Request.TotalBytes
b=Request.BinaryRead(a)
set obj=server.createobject("basp21")

' 接收輸入項傳過來的值
content=obj.Form(b,"content")    ' 接收由上一個form輸入項傳入之值，content 為上一支程式之輸入項

' 底下接收檔案
f1=obj.FormFileName(b,"file1")     '  file1  為上一支程式選檔之輸入項名稱

' 檔案長度
fsize=obj.FormFileSize(b,"file1")    ' 檔案長度

fname=Mid(f1,InstrRev(f1,"\")+1)    '檔案名稱

l1=obj.FormSaveAs(b,"file1","c:\1688\" & fname)     '存檔，儲存位置為硬碟上之絕對路徑。此路徑必須存在
                                                   '以本例而言，將上傳檔案存在c:\1688資料夾

'底下標註程式為寫入資料庫程式範例
'set db=server.createobject("adodb.connection")
'set rs=server.createobject("adodb.recordset")
'db.Open "Driver={Microsoft Access Driver (*.mdb)};DBQ=" & Server.MapPath("1688.mdb")
'rs.open "smtest",db,1,3

if l1>0 then    ' 若成功，傳回大於0之值
'   rs.addnew
'   rs("file1")=fname   '檔名
   response.write "上傳檔案：" & fname & "，檔案長度：" & fsize &"<BR>"
else
   response.write "上傳檔案失敗!!"   
end if

'rs("content")=content     '檔案說明文字   
'rs.update
'rs.close
'db.close
'set db=nothing
%>
</BODY></HTML>
