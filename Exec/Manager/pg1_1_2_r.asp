<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  HtmlHeader('復查決定書-資料維護-結果');

  // 檢查所有資料
  function CheckAll()
  {
    // Check Fields
    if (
        RequirePass(
            new Array(
              'DOCNO', '文號'
            )
        )
        &&
        UniquePass('DDQS_DOC',
            new Array(
              'DOCNO', '文號'
            )
        )
       )
    {
      if (Rcv.Item('IDNO') != '')
      {
        Rcv.SetItem('IDNO', Rcv.Item('IDNO').toUpperCase());

        if (Rcv.Item('IDNO').length == 8)
        {
          if (!CheckBAN(Rcv.Item('IDNO')))
          {
            ErrorMsg("統一編號欄位資料格式錯誤, 請輸入BAN或是IDN.");
            return false;
          }
        }
        else
        {
          if (!CheckIDN(Rcv.Item('IDNO')))
          {
            ErrorMsg("統一編號欄位資料格式錯誤, 請輸入BAN或是IDN.");
            return false;
          }
        }
      }

      return true;
    }
    else
      return false;
  }

  if (Rcv.Item('_action') == '新增')
  {
    CheckAll();

    Rcv.SetItem('DOC_TYPE', '1');

    if (Rcv.Item('INDEX1_idx') == '')
      Rcv.SetItem('INDEX1_idx', null);

    if (Rcv.Item('SEND_DATE') == '')
      Rcv.SetItem('SEND_DATE', null);

    Qry = SQLExecute("select newid()");
    if (!Qry.Eof)
      Rcv.SetItem('rowguid', Qry.Fields(0));

    MkDir(ToRealFilePath("/") + "\\FileStore\\" + Rcv.Item('rowguid'));
    FileRename(ToRealFilePath("/") + "\\FileStore\\" + Rcv.Item('FILE_NAME'), ToRealFilePath("/") + "\\FileStore\\" + Rcv.Item('rowguid') + "\\" + Rcv.Item('FILE_NAME'));

    NewInsertTable('DDQS_DOC', true);

    LogWRITE(Rcv.Item('DOCNO'), 1);

    ShowMessage('新增作業完成.', new Array('繼續新增', "location.href='pg1_1_2_n.asp'", '回瀏覽頁', "location.href='pg1_1_2.asp'"));
  }
  else if (Rcv.Item('_action') == '修改')
  {
    if (Rcv.Item('INDEX1_idx') == '')
      Rcv.SetItem('INDEX1_idx', null);

    if (Rcv.Item('SEND_DATE') == '')
      Rcv.SetItem('SEND_DATE', null);

    UpdateTable('DDQS_DOC', "rowguid='" + Rcv.Item('rowguid') + "'");

    ShowMessage('資料修改完成.', new Array('回明細頁', "location.href='pg1_1_2_d.asp?rowguid=" + Rcv.Item('rowguid') + "'"));
  }
  else if (Rcv.Item('_action') == '刪除')
  {
    SQLExecute("delete from DDQS_DOC where rowguid='" + Rcv.Item('rowguid') + "'");

    ShowMessage('資料刪除完成.', new Array('回瀏覽頁', "location.href='pg1_1_2.asp'"));
  }
%>
