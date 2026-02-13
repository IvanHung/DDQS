<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  var Sav = new QrySave();
  
  Session('editing_user_rowguid') = null;
    
  if (Rcv.Item('rowguid') != '')
  {
    Session('editing_user_rowguid') = ''+Rcv.Item('rowguid');
    
    Sav.Exec("select * from webap_user where rowguid = '" + Rcv.Item('rowguid') + "'");
  
    if (Sav.Item('user_last_login_ip')=='')
    {
      Sav.SetItem('user_last_login_ip', '未登入過');
      Sav.SetItem('user_last_login_success_time', '無');
      Sav.SetItem('user_last_login_fail_time', '無');
    };
    
    SubTitle = '明細';
  }
  else
  {
    Sav.SetItem('user_last_login_ip', '未登入過');
    Sav.SetItem('user_last_login_success_time', '無');
    Sav.SetItem('user_last_login_fail_time', '無');
    
    var user_create_dateObj = new Date();
    Sav.SetItem('user_create_date', ACDateToStr() + ' ' + ACTimeToStr());
    
    SubTitle = '新增';
  };
%>
<%
  HtmlHeader('系統管理 - 使用者管理 - ' + SubTitle);
%>
<body>

<table border="0" cellpadding="1" cellspacing="1" height="100%" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td align="middle" nowrap valign="center">
      <br>
      <table border=3 cellpadding=2 cellspacing=5 width="80%" height="80%" bgcolor=white borderColor=#8080FF style="margin-bottom: 1px;" >
        <tr>
          <td align=center valign=center nowrap>
<%
  if (Rcv.Item('rowguid') != '')
    var BtnArray = new Array(
          'submit', '修改',
          'submit', '刪除',
          'submit', '解除鎖定',
          "location.href='user_man.asp?user_role_id=" + Sav.Item('user_role_id') + "'", '回瀏覽頁'
        );
  else
    var BtnArray = new Array(
          'submit', '新增',
          "location.href='user_man.asp?user_role_id=" + Sav.Item('user_role_id') + "'", '回瀏覽頁'
        );
    
  var FreeEdit = false;
  if (IsNull(Sav.Item('user_role_id')) || Sav.Item('user_role_id') == '0')
    FreeEdit = true;

  if (Rcv.Item('rowguid') == '')
  {
    if (Rcv.Item('_action') == 'GetOA' && (Rcv.Item('_GET_OA_ID') != '' || Rcv.Item('_GET_OA_ID_BY_EMPNO') != ''))
    {
      var Qry = SQLExecute("select * from EMPL_VIEW where USERID='" + Rcv.Item('_GET_OA_ID') + "'");
      
      if (Rcv.Item('_GET_OA_ID_BY_EMPNO') != '')
      {
        Qry = SQLExecute("select * from EMPL_VIEW where USERID ='" + Rcv.Item('_GET_OA_ID_BY_EMPNO') + "'");
        Rcv.SetItem('_GET_OA_ID_BY_EMPNO', '');
        Rcv.SetItem('_GET_OA_ID', ''+Qry('USERID'));
      }
      else
        Qry = SQLExecute("select * from EMPL_VIEW where USERID='" + Rcv.Item('_GET_OA_ID') + "'");

      Rcv.SetItem('user_id', ''+Qry('USERID'));
      Rcv.SetItem('user_password', ''+Qry('USERID'));
      Rcv.SetItem('user_name', ''+Qry('USERNM'));
      Rcv.SetItem('user_idn', (''+Qry('USERID')).substr(3, 5));
      Rcv.SetItem('user_role_id', '2');

      FreeEdit = false;
    }

    CreateUI('user_detail_r.asp', 'mainform', true, true, 
        BtnArray, 
        new Array(
          new Array('text', '帶入OA使用者(編號):', '_GET_OA_ID_BY_EMPNO', 'rw', '', 5, 5, "><input type=button value=\"查詢\" onclick=\"mainform.action='user_detail.asp?_action=GetOA';mainform.submit();\""),
          new Array('sqlcombobox', '帶入OA使用者:', '_GET_OA_ID', 'rw', '', 'USERID', 'NM', "select USERID, USERID + '.' + DEPTNM + '.' + USERNM NM from EMPL_VIEW order by DEPTNM, USERNM", true, "onchange=\"mainform.action='user_detail.asp?_action=GetOA';mainform.submit();\""),
          new Array('text', '使用者編號:', 'user_id', (FreeEdit?'w':'r'), '', 10, 10, ''),
          new Array('passwd', '使用者密碼:', 'user_password', (FreeEdit?'rw':'r'), '', 10, 10, ''),
          new Array('text', '姓名:', 'user_name', (FreeEdit?'w':'r'), '', 12, 12, ''),
          new Array('text', '員工編號:', 'user_idn', (FreeEdit?'w':'r'), '', 10, 10, ''),
          new Array('text', '單位:', 'user_unit', 'r', GetSelectText("select SECTN_CHI_NM from QICT105, QICT010 where EMPL_CD='" + Rcv.Item('user_id').substr(3, 5) + "' and QICT010.DIVISION_CD=QICT105.DIVISION_CD and QICT010.ORG_CD+QICT010.SECTN_CD=QICT105.ORG_SECTN"), 20, 20, ''),
          new Array('code', '角色:', 'user_role_id', 'w', '', 'S0', true, ''),
          new Array('bool', '使用者有效:', 'user_enabled', 'rw', 'Y', '')
        )
      );
  }
  else
  {
    CreateUI('user_detail_r.asp', 'mainform', true, false, 
        BtnArray, 
        new Array(
          new Array('text', '使用者編號:', 'user_id', (FreeEdit?'w':'r'), '', 10, 10, ''),
          new Array('passwd', '使用者密碼:', 'user_password', (FreeEdit?'rw':'r'), '', 10, 10, ''),
          new Array('text', '姓名:', 'user_name', (FreeEdit?'w':'r'), '', 12, 12, ''),
          new Array('text', '員工編號:', 'user_idn', (FreeEdit?'w':'r'), '', 10, 10, ''),
          new Array('text', '單位:', 'user_unit', 'r', GetSelectText("select SECTN_CHI_NM from QICT105, QICT010 where EMPL_CD='" + Sav.Item('user_id').substr(3, 5) + "' and QICT010.DIVISION_CD=QICT105.DIVISION_CD and QICT010.ORG_CD+QICT010.SECTN_CD=QICT105.ORG_SECTN"), 20, 20, ''),
          new Array('code', '角色:', 'user_role_id', 'w', '', 'S0', true, ''),
          new Array('bool', '使用者有效:', 'user_enabled', 'rw', 'Y', ''),
          new Array('bool', '使用者已被鎖定:', '_user_is_lock', 'r', Sav.Item('user_login_fail_count') >= 5 ? 'Y':'N', ''),

          new Array('text', '建檔日期:', 'user_create_date', 'r', '', 20, 20, ''),
          new Array('text', '上次登入IP位址:', 'user_last_login_ip', 'r', '', 20, 20, ''),
          new Array('text', '上次登入成功時間:', 'user_last_login_success_time', 'r', '', 20, 20, ''),
          new Array('text', '上次登入失敗時間:', 'user_last_login_fail_time', 'r', '', 20, 20, ''),
        
          new Array('hidden', 'rowguid', '', '')
        )
      );
  }
%>
          </tr>
        </td>
      </table>
      <br>
      <input class="button" type="button" value="回選單頁" style="width:200px;" onclick="location.href='sys_menu.asp'">
    </td>
  </tr>
</table>

</body>

</html>
<%
  Sav = null;
%>