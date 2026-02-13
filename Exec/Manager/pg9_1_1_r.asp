<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  HtmlHeader('資料維護-稅目維護-結果');

  // 檢查所有資料
  function CheckAll()
  {
    // Check Fields
    if (
        RequirePass(
            new Array(
              'INDEX1', '稅目'
            )
        )
       )
      return true;
    else
      return false;
  }

  CheckAll();

  if (Rcv.Item('_action') == '修改')
  {
    UpdateTable('DDQS_INDEX1', "rowguid='" + Rcv.Item('rowguid') + "'");

    ShowMessage('修改存檔完成.', new Array('回瀏覽頁', "location.href='pg9_1_1.asp'"));
  }
  else if (Rcv.Item('_action') == '新增')
  {
    NewInsertTable('DDQS_INDEX1');

    ShowMessage('新增作業完成.', new Array('繼續新增', "location.href='pg9_1_1_d.asp'", '回瀏覽頁', "location.href='pg9_1_1.asp'"));
  }
  else if (Rcv.Item('_action') == '刪除')
  {
    var Qry = SQLExecute("select * from DDQS_INDEX2 where INDEX1_rowguid='" + Rcv.Item('rowguid') + "'");

    while (!Qry.Eof)
    {
      SQLExecute("delete from DDQS_KEYS where INDEX2_rowguid='" + Qry('rowguid') + "'");
      Qry.moveNext;
    }
    Qry.Close();

    SQLExecute("delete from DDQS_INDEX2 where INDEX1_rowguid='" + Rcv.Item('rowguid') + "'");
    SQLExecute("delete from DDQS_INDEX1 where rowguid='" + Rcv.Item('rowguid') + "'");

    ShowMessage('資料刪除完成.', new Array('回瀏覽頁', "location.href='pg9_1_1.asp'"));
  }
%>
