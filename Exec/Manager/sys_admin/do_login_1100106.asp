<%@ Language=JavaScript %>
<!--#include file="_lib.asp" -->
<%
  ReDBConnect();

  var RetValue = '';
    
  Session('user_name') = null;
  Session('login_time') = null;
  Session('user_id') = null;
  Session('user_rowguid') = null;
  Session('root_menu') = null;
    
  var Qry = SQLExecute("select * from webap_user where user_role_id = '0'");
    
  if (Qry.Eof && (Rcv.Item('user_id').toUpperCase() == 'SYSTEM') && (Rcv.Item('user_password').toUpperCase() == 'MANAGER'))
  {
    Session('user_name') = '預設系統管理員';
    Session('login_time') = ACDateToStr() + " " + ACTimeToStr();
    Session('user_id') = ('' + Rcv.Item('user_id')).toUpperCase();
  };
    
  Qry.Close;
  Qry = null;
  
  if (IsNull(Session('user_name')))
  {
    var Qry = SQLExecute(
      "select * from webap_user where Upper(user_id) = '" + (''+Rcv.Item('user_id')).toUpperCase() + "'");
        
    if (Qry.Eof)
      RetValue = '使用者編號不存在, 請重新登入.';
    else
    {
      if (Qry('user_login_fail_count') >= 5)
      {
        var locktime = new Date(Qry('user_last_login_fail_time'));
        locktime.setTime(locktime.getTime() + 1000*60*60);
        var now = new Date();
        if (now < locktime)
        {
          SQLExecute(
            "update webap_user set " + 
            "user_last_login_ip = '" + Request.ServerVariables('REMOTE_ADDR') + "', " +
            "user_last_login_fail_time = getdate(), " +
            "user_login_fail_count = user_login_fail_count + 1 " +
            "where Upper(user_id) = '" + (''+Rcv.Item('user_id')).toUpperCase() + "'");
          now.setTime(now.getTime() + 1000*60*60);
          RetValue += '使用者密碼錯誤達五次以上, 使用者已被鎖定. 將於' + ACDateToStr(now) + ' ' + ACTimeToStr(now) + '解鎖.';
          SaveLog(RetValue + ' (LoginID:' + Rcv.Item('user_id') + ')');
        }
       }

      if (IsNull(RetValue))
      {
        if ((''+Qry('user_password')).toUpperCase() != ''+Rcv.Item('user_password'))
        {
          SQLExecute(
            "update webap_user set " + 
            "user_last_login_ip = '" + Request.ServerVariables('REMOTE_ADDR') + "', " +
            "user_last_login_fail_time = getdate(), " +
            "user_login_fail_count = user_login_fail_count + 1 " +
            "where Upper(user_id) = '" + (''+Rcv.Item('user_id')).toUpperCase() + "'");
          RetValue = '使用者密碼錯誤, 請重新登入.';
          if (Qry('user_login_fail_count') < 4)
            RetValue = RetValue + ' 您尚有' + (5-Qry('user_login_fail_count')) + '次重新登入機會.'
          else
            RetValue = RetValue + ' 您僅剩最後一次重新登入機會.'
        }
        else if (''+Qry('user_role_id') != '0')
          RetValue = '使用者沒有權限使用系統管理功能, 請重新登入.';
        else
        {
          SQLExecute(
            "update webap_user set " + 
            "user_last_login_ip = '" + Request.ServerVariables('REMOTE_ADDR') + "', " +
            "user_last_login_success_time = getdate(), " +
            "user_login_fail_count = 0 " +
            "where Upper(user_id) = '" + (''+Rcv.Item('user_id')).toUpperCase() + "'");
              
          Session('user_name') = "" + Qry('user_name');
          Session('login_time') = ACDateToStr() + " " + ACTimeToStr();
          Session('user_rowguid') = '' + Qry('rowguid');
          Session('user_id') = ('' + Rcv.Item('user_id')).toUpperCase();
        };
      };
    };
      
    Qry.Close;
    Qry = null;
  };
  
  Session('user_role_id') = '0';
  
  if (IsNull(RetValue))
  {
    Session('root_menu') = 'sys_menu.asp';
    Response.Redirect(Session('root_menu'));
  }
  else
  {
    Session('root_menu') = null;
    ErrorMsg(RetValue);
  };
%>
