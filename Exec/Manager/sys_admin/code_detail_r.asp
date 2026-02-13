<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  Rcv.SetItem('code_kind', Rcv.Item('code_kind').toUpperCase());
  Rcv.SetItem('code_id', Rcv.Item('code_id').toUpperCase());
  
  if (Rcv.Item('_action') == '新增')
  {
    var Qry = SQLExecute("select * from webap_code " + 
        "where code_kind = '" + Rcv.Item('code_kind') + "' " + 
        "and code_id = '" + Rcv.Item('code_id') + "'");
        
    if (!Qry.Eof)
      ErrorMsg('代碼類別:' + Rcv.Item('code_kind') + ' 代碼編號:' + Rcv.Item('code_id') + ' 已存在.');
    else
    {
      SQLExecute("insert into webap_code (code_kind, code_id, code_content, code_descript, code_order) " + 
          "values ('" + Rcv.Item('code_kind') + "', " +
          "'" + Rcv.Item('code_id') + "', " + 
          "'" + Rcv.Item('code_content') + "', " + 
          "'" + Rcv.Item('code_descript') + "', " + 
          "'" + Rcv.Item('code_order') + "')");
      ShowMessage('新增完成.', 
          new Array('回瀏覽頁', "location.href='code_man.asp?code_kind=" + Rcv.Item('code_kind') + "'", 
          '繼續新增', "location.href='code_detail.asp?code_kind=" + Rcv.Item('code_kind') + "'"));
    }
    
    Qry.Close;
    Qry = null;
  }
  else if (Rcv.Item('_action') == '修改')
  {
    var Qry = SQLExecute("select * from webap_code " + 
        "where rowguid = '" + Rcv.Item('rowguid') + "'");
        
    if (Qry.Eof)
      ErrorMsg('代碼資料不存在.');
    else
    {
      var Qry2 = SQLExecute("select * from webap_code " + 
          "where code_kind = '" + Rcv.Item('code_kind') + "' " + 
          "and code_id = '" + Rcv.Item('code_id') + "' " + 
          "and rowguid <> '" + Rcv.Item('rowguid') + "'");
      if (!Qry2.Eof)
        ErrorMsg('代碼類別:' + Rcv.Item('code_kind') + ' 代碼編號:' + Rcv.Item('code_id') + ' 已存在.');
      else
      {
        if (Qry('code_kind') == '0')
          SQLExecute("update webap_code " + 
              "set code_kind = '" + Rcv.Item('code_id') + "' " +
              "where code_kind = '" + Qry('code_id') + "'");
        SQLExecute("update webap_code " + 
            "set code_kind = '" + Rcv.Item('code_kind') + "', " +
            "code_id = '" + Rcv.Item('code_id') + "', " + 
            "code_content = '" + Rcv.Item('code_content') + "', " + 
            "code_descript = '" + Rcv.Item('code_descript') + "', " + 
            "code_order = '" + Rcv.Item('code_order') + "' " + 
            "where rowguid = '" + Rcv.Item('rowguid') + "'");
        ShowMessage('修改完成.', 
            new Array('回瀏覽頁', "location.href='code_man.asp?code_kind=" + Rcv.Item('code_kind') + "'",
            '繼續修改/新增', "location.href='code_detail.asp?rowguid=" + Rcv.Item('rowguid') + "'"));
      }
      
      Qry2.Close;
      Qry2 = null;
    }
    
    Qry.Close;
    Qry = null;
  }
  else if (Rcv.Item('_action') == '刪除')
  {
    var Qry = SQLExecute("select * from webap_code " + 
        "where rowguid = '" + Rcv.Item('rowguid') + "'");
        
    if (Qry.Eof)
      ErrorMsg('代碼資料不存在.');
    else
    {
      if (Qry('code_kind') == '0')
        SQLExecute("delete from webap_code " + 
            "where code_kind = '" + Qry('code_id') + "'");
      SQLExecute("delete from webap_code " + 
          "where rowguid = '" + Rcv.Item('rowguid') + "'");
      ShowMessage('刪除完成.', 
          new Array('回瀏覽頁', "location.href='code_man.asp?code_kind=" + Rcv.Item('code_kind') + "'"));
    }
    
    Qry.Close;
    Qry = null;
  }
%>
