<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  HtmlHeader('關鍵字維護-結果');

  // 檢查所有資料
  function CheckAll()
  {
    // Check Fields
    if (
        RequirePass(
            new Array(
              'INDEX2_rowguid', '項目',
              'KEYS', '關鍵字'
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
    UpdateTable('DDQS_KEYS', "rowguid='" + Rcv.Item('rowguid') + "'");

    ShowMessage('修改存檔完成.', new Array('回瀏覽頁', "location.href='pg9_1_3.asp'"));
  }
  else if (Rcv.Item('_action') == '新增')
  {
    NewInsertTable('DDQS_KEYS');

    Session('Search_INDEX1') = Rcv.Item('_INDEX1_rowguid');
    Session('Search_INDEX2') = Rcv.Item('INDEX2_rowguid');

    ShowMessage('新增作業完成.', new Array('繼續新增', "location.href='pg9_1_3_d.asp'", '回瀏覽頁', "location.href='pg9_1_3.asp'"));
  }
  else if (Rcv.Item('_action') == '刪除')
  {
    SQLExecute("delete from DDQS_KEYS where rowguid='" + Rcv.Item('rowguid') + "'");

    ShowMessage('資料刪除完成.', new Array('回瀏覽頁', "location.href='pg9_1_3.asp'"));
  }
%>
