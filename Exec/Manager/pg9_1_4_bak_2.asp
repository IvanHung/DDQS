<%@  Language=JavaScript %>
<!--#include file="_lib.asp" -->
<!--#include file="check_user.asp" -->
<html>
<%
  HtmlHeader('資料維護-作業紀錄查詢');
  SetPagesHome();
%>
<body>

<table border="0" class=pagetable cellpadding="1" cellspacing="1" width="100%">
  <%
  ContentHeader();
  %>
  <tr>
    <td nowrap align="center" valign="center" height=20>
<%
  var USER_ID = '';

  if (!IsNull(Rcv.Item('rowguid')))
  {
    USER_ID = Rcv.Item('rowguid');
    Rcv.SetItem('rowguid', '');
  }

/*
  if (!IsNull(Rcv.Item('_DO_QUERY')))
    SaveRCV();
  else
    LoadRCV();
*/

  if (!IsNull(USER_ID))
    Rcv.SetItem('USER_ID', USER_ID);

  CreateUI('pg9_1_4.asp', 'mainform', false, true,
      new Array(
        'submit', '查詢'
      ),
      new Array(
        // 案件內容
        new Array('customcombobox', '文件類別:', 'DOC_TYPE', 'rw', '', new Array('', '全部', '1', '復查決定書', '2', '訴願決定書', '3', '行政訴訟裁判書'), false, ''),
        new Array('customcombobox', '類別:', 'ACCESS_REC', 'rw', '', new Array('', '全部', 'READ', '讀取', 'WRITE', '寫入'), false, ''),
        new Array('sqlcombobox', '使用者:', 'USER_ID', 'rw', '', 'user_id', 'user_name',
            " select user_id, USER_ID + ' ' + SECTN_CHI_NM + '.' + EMPL_NM user_name " +
            " from webap_user, QICT105, QICT010 " +
            " where user_role_id<>'0' " +
            " and Left(ORG_SECTN, 3) + EMPL_CD = USER_ID collate Chinese_Taiwan_Stroke_CI_AS" +
            " and ORG_SECTN = ORG_CD+SECTN_CD " +
            " and QICT010.DIVISION_CD = '00' " +
            " order by user_role_id, SECTN_CHI_NM + '.' + EMPL_NM",
            true, ''),
        new Array('text', '文號:', 'DOCNO', 'rw', '', 20, 20, ''),
        new Array('hidden', '_DO_QUERY', 'true', '')
      )
    );

  if (IsNull(Rcv.Item('USER_ID')))
  {
    BrowseData("select " +
      " case DOC_TYPE when '2' then '訴願決定書' when '3' then '行政訴訟裁判書' else '復查決定書' end as DOC_TYPE, " +
      " case ACCESS_REC when 'WRITE' then '寫入' else '讀取' end as ACCESS_REC, " +
      " USER_ID collate Chinese_Taiwan_Stroke_CI_AS+ ' ' + SECTN_CHI_NM + '.' + EMPL_NM as USER_NAME, " +
      " dbo.GetChDateStr(max(EDATE)) as LAST_EDATE, USER_ID as rowguid " +
      " from DDQS_LOG, QICT105, QICT010 " +
      " where Left(ORG_SECTN, 3) + EMPL_CD = USER_ID collate Chinese_Taiwan_Stroke_CI_AS" +
      " and ORG_SECTN = ORG_CD+SECTN_CD " +
      " and QICT010.DIVISION_CD = '00' " +
      " and " + Rcv.GetSqlSearchWhereConStr() +
      " group by DOC_TYPE, ACCESS_REC, USER_ID collate Chinese_Taiwan_Stroke_CI_AS+ ' ' + SECTN_CHI_NM + '.' + EMPL_NM, USER_ID " +
      " order by max(EDATE) desc ",
      new Array('DOC_TYPE', 'ACCESS_REC', 'USER_NAME', 'LAST_EDATE'),
      new Array('文件類別', '操作', '使用者名稱', '最近操作日期'),
      'pg9_1_4.asp', false, '', '', '');
  }
  else
  {
    BrowseData("select " +
      " case DOC_TYPE when '2' then '訴願決定書' when '3' then '行政訴訟裁判書' else '復查決定書' end as DOC_TYPE, " +
      " case ACCESS_REC when 'WRITE' then '寫入' else '讀取' end as REC, " +
      " USER_ID + ' ' + SECTN_CHI_NM + '.' + EMPL_NM as USER_NAME, " +
      " DOCNO, dbo.GetChDateStr(EDATE) + ' ' + ETIME as EDATE_TIME " +
      " from DDQS_LOG, QICT105, QICT010 " +
      " where Left(ORG_SECTN, 3) + EMPL_CD = USER_ID collate Chinese_Taiwan_Stroke_CI_AS" +
      " and ORG_SECTN = ORG_CD+SECTN_CD " +
      " and QICT010.DIVISION_CD = '00' " +
      " and " + Rcv.GetSqlSearchWhereConStr() +
      " order by EDATE desc, ETIME desc ",
      new Array('DOC_TYPE', 'REC', 'USER_NAME', 'DOCNO', 'EDATE_TIME'),
      new Array('文件類別', '操作', '使用者名稱', '文號', '操作日期'),
      '', false, '', '', '');
  }
%>
    </td>
  </tr>
</table>

</body>

</html>
