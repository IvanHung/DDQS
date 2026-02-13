<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  HtmlHeader('資料維護-項目維護-結果');

  // 檢查所有資料
  function CheckAll()
  {
    // Check Fields
    if (
        RequirePass(
            new Array(
              'INDEX1_rowguid', '稅目',
              'INDEX2', '項目'
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
    UpdateTable('DDQS_INDEX2', "rowguid='" + Rcv.Item('rowguid') + "'");

    ShowMessage('修改存檔完成.', new Array('回瀏覽頁', "location.href='pg9_1_2.asp'"));
  }
  else if (Rcv.Item('_action') == '新增')
  {
    NewInsertTable('DDQS_INDEX2');

    Session('Search_INDEX1') = Rcv.Item('INDEX1_rowguid');

    ShowMessage('新增作業完成.', new Array('繼續新增', "location.href='pg9_1_2_d.asp'", '回瀏覽頁', "location.href='pg9_1_2.asp'"));
  }
  else if (Rcv.Item('_action') == '刪除')
  {
    SQLExecute("delete from DDQS_KEYS where INDEX2_rowguid='" + Rcv.Item('rowguid') + "'");
    SQLExecute("delete from DDQS_INDEX2 where rowguid='" + Rcv.Item('rowguid') + "'");

    ShowMessage('資料刪除完成.', new Array('回瀏覽頁', "location.href='pg9_1_2.asp'"));
  }
%>
