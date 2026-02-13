<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<%
  if (Rcv.Item('_action') == '批次加入使用者')
  {
    SQLExecute(
        "update webap_user " +
        "set " + 
        "user_enabled=case when INJOB_MK='Y' then 'Y' else 'N' end, " +
        "user_id=EMPL_CD, " +
        "user_name=EMPL_NM " +
        "from NTAK_DATA.QICT105 " +
        "where webap_user.user_idn = EMPL_CD "
        );
        
    SQLExecute(
        "insert into webap_user " + 
        "([user_id], [user_password], [user_name], [user_idn], [user_role_id], [user_enabled], [user_unit]) " +
        "select  " +
        "EMPL_CD user_id,  " +
        "EMPL_CD user_password,  " +
        "EMPL_NM user_name,  " +
        "EMPL_CD user_idn,  " +
        "'2' user_role_id, " +
        "INJOB_MK user_enabled, " +
        "'' user_unit " +
        "from NTAK_DATA.QICT105 " +
        "where ORG_SECTN = '" + Rcv.Item('_DDEPT') + "' " + 
        " and not exists " +
        "( select * from webap_user " +
        "  where webap_user.user_idn = EMPL_CD) " 
        );
        
    ShowMessage('批次加入使用者完成.<br><br>系統已將新加入的使用者設定為[查詢作業人員], 請您再自行更改使用者角色.', 
        new Array('回瀏覽頁', "location.href='user_man.asp';"));
  }
  else if (Rcv.Item('_action') == '批次移除使用者')
  {
    SQLExecute(
        "delete from webap_user " +
        "from NTAK_DATA.QICT105 " +
        "where user_idn = EMPL_CD " +
        "and ORG_SECTN = '" + Rcv.Item('_DDEPT') + "' " 
        );
        
    ShowMessage('批次移除使用者完成.', 
        new Array('回瀏覽頁', "location.href='user_man.asp';"));
  }
%>
