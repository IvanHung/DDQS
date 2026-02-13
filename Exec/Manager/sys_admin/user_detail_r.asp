<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  Rcv.SetItem('user_id', Rcv.Item('user_id').toUpperCase());
  Rcv.SetItem('user_idn', Rcv.Item('user_idn').toUpperCase());
  
  if (Rcv.Item('_action') == '解除鎖定')
  {
    SQLExecute("update webap_user " + 
        "set user_login_fail_count = 0 " +
        "where rowguid = '" + Rcv.Item('rowguid') + "'");
    ShowMessage('解除鎖定完成.', 
        new Array('回瀏覽頁', "location.href='user_man.asp?user_role_id=" + Rcv.Item('user_role_id') + "'"));
  }
  else if (Rcv.Item('_action') == '由OA系統帶入資料')
  {
    if (Rcv.Item('user_id').length < 4)
      ErrorMsg('使用者編號必須至少4個英數字元長, 請重新輸入.');
    else if (Rcv.Item('user_role_id') == '')
      ErrorMsg('角色編號必須輸入, 請重新輸入.');
    else
    {
      var OAQry = SQLExecute("select * from EMPLOYEE " + 
        "where USERID='" + Rcv.Item('user_id') + "'");
        
      if (OAQry.Eof)
        ErrorMsg('OA系統資料不存在.');
      
      Rcv.SetItem('user_name', OAQry('USERNM'));
      Rcv.SetItem('user_idn', OAQry('EMPL_CD'));
      //Rcv.SetItem('user_unit', OAQry('DEPT_ID'));
      
      if (IsNull(Rcv.Item('user_password')))
        Rcv.SetItem('user_password', Rcv.Item('user_id'));
      
      var Qry = SQLExecute("select * from webap_user " + 
          "where user_id = '" + Rcv.Item('user_id') + "'");
      if (!Qry.Eof)
        ErrorMsg('使用者編號:' + Rcv.Item('user_id') + ' 已存在.');
      else
      {
        SQLExecute("insert into webap_user " + 
            "(user_id, user_password, user_name, user_idn, user_role_id, user_enabled, user_unit) " + 
            "values ('" + Rcv.Item('user_id') + "', '" + Rcv.Item('user_password') + "', '" + 
            Rcv.Item('user_name') + "', '" + Rcv.Item('user_idn') + "', '" + Rcv.Item('user_role_id') + "', '" + Rcv.Item('user_enabled') + "', '')");
        ShowMessage('新增完成.', 
            new Array('回瀏覽頁', "location.href='user_man.asp?user_role_id=" + Rcv.Item('user_role_id') + "'", 
            '繼續新增', "location.href='user_detail.asp?user_role_id=" + Rcv.Item('user_role_id') + "'"));
      }
      Qry.Close;
      Qry = null;
    }
  }
  else if (Rcv.Item('_action') == '新增')
  {
    if (Rcv.Item('user_id').length < 4)
      ErrorMsg('使用者編號必須至少4個英數字元長, 請重新輸入.');
    else if (Rcv.Item('user_name').length < 2)
      ErrorMsg('姓名必須至少2個字元長, 請重新輸入.');
    else if (IsNull(Rcv.Item('user_idn')))
      ErrorMsg('員工編號必須輸入, 請重新輸入.');
    else if (Rcv.Item('user_role_id') == '')
      ErrorMsg('角色編號必須輸入, 請重新輸入.');
    else
    {    
      var Qry = SQLExecute("select * from webap_user " + 
          "where user_id = '" + Rcv.Item('user_id') + "'");
      if (!Qry.Eof)
        ErrorMsg('使用者編號:' + Rcv.Item('user_id') + ' 已存在.');
      else
      {
        SQLExecute("insert into webap_user " + 
            "(user_id, user_password, user_name, user_idn, user_role_id, user_enabled, user_unit) " + 
            "values ('" + Rcv.Item('user_id') + "', '" + Rcv.Item('user_password') + "', '" + 
            Rcv.Item('user_name') + "', '" + Rcv.Item('user_idn') + "', '" + Rcv.Item('user_role_id') + "', '" + Rcv.Item('user_enabled') + "', '')");
        ShowMessage('新增完成.', 
            new Array('回瀏覽頁', "location.href='user_man.asp?user_role_id=" + Rcv.Item('user_role_id') + "'", 
            '繼續新增', "location.href='user_detail.asp?user_role_id=" + Rcv.Item('user_role_id') + "'"));
      }
      Qry.Close;
      Qry = null;
    }
  }
  else if (Rcv.Item('_action') == '修改')
  {
    if (Rcv.Item('user_id').length < 4)
      ErrorMsg('使用者編號必須至少4個英數字元長, 請重新輸入.');
    else if (Rcv.Item('user_name').length < 2)
      ErrorMsg('姓名必須至少2個字元長, 請重新輸入.');
    else if (IsNull(Rcv.Item('user_idn')))
      ErrorMsg('員工編號必須輸入, 請重新輸入.');
    else if (Rcv.Item('user_role_id') == '')
      ErrorMsg('角色編號必須輸入, 請重新輸入.');
    else
    {    
      var Qry = SQLExecute("select * from webap_user " + 
        "where rowguid='" + Rcv.Item('rowguid') + "'");
      if (Qry.Eof)
        ErrorMsg('使用者資料不存在.');
      else
      {
        var Qry2 = SQLExecute("select * from webap_user " + 
            "where user_id = '" + Rcv.Item('user_id') + "' " + 
            "and rowguid <> '" + Rcv.Item('rowguid') + "'");
        if (!Qry2.Eof)
          ErrorMsg('使用者編號:' + Rcv.Item('user_id') + ' 已存在.');
        else
        {
          SQLExecute("update webap_user " + 
              "set user_id = '" + Rcv.Item('user_id') + "', " +
              "user_password = '" + Rcv.Item('user_password') + "', " + 
              "user_name = '" + Rcv.Item('user_name') + "', " +
              "user_idn = '" + Rcv.Item('user_idn') + "', " +
              "user_role_id = '" + Rcv.Item('user_role_id') + "', " +
              "user_enabled = '" + Rcv.Item('user_enabled') + "', " +
              "user_unit = '' " +
              "where rowguid = '" + Rcv.Item('rowguid') + "'");
          ShowMessage('修改完成.', 
              new Array('回瀏覽頁', "location.href='user_man.asp?user_role_id=" + Rcv.Item('user_role_id') + "'"));
        }
        Qry2.Close;
        Qry2 = null;
      }
      Qry.Close;
      Qry = null;
    }
  }
  else if (Rcv.Item('_action') == '刪除')
  {
    var Qry = SQLExecute("select * from webap_user " + 
      "where rowguid = '" + Rcv.Item('rowguid') + "'");
    if (Qry.Eof)
      ErrorMsg('使用者資料不存在.');
    else
    {
      SQLExecute("delete from webap_user " + 
          "where rowguid = '" + Rcv.Item('rowguid') + "'");
      ShowMessage('刪除完成.', 
          new Array('回瀏覽頁', "location.href='user_man.asp?user_role_id=" + Rcv.Item('user_role_id') + "'"));
    }
    Qry.Close;
    Qry = null;
  }
%>
