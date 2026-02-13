<%
  function OnlyRole(val)
  {
    var valCode = GetSelectText("select code_id from webap_code where code_content='" + val + "'");

    var SubRoleIdArray = Session('user_subrole_id_array');

    if (SubRoleIdArray == null)
      return false;

    if (SubRoleIdArray.length == 1 && SubRoleIdArray[0] == valCode)
      return true;
    else
      return false;
  }

  function HasRole(val)
  {
    var valCode = GetSelectText("select code_id from webap_code where code_content='" + val + "'");

    var SubRoleIdArray = Session('user_subrole_id_array');

    if (SubRoleIdArray == null)
      return false;

    for (var i=0; i<SubRoleIdArray.length; i++)
      if (SubRoleIdArray[i] == valCode)
        return true;

    return false;
  }

  function AppendDDQS_LOG(REC, DOCNO, DOC_TYPE)
  {
    if (GetSelectCount("select count(*) from DDQS_LOG " +
        "where DOC_TYPE='" + DOC_TYPE + "' " +
        "and ACCESS_REC='" + REC + "' " +
        "and USER_ID='" + Session('user_id') + "' " +
        "and cast(EDATE as varchar)=cast(getdate() as varchar)") == 0)
      SQLExecute("insert into DDQS_LOG (DOC_TYPE, ACCESS_REC, USER_ID, DOCNO, EDATE, ETIME) " +
          "values ('" + DOC_TYPE + "', '" + REC + "', '" + Session('user_id') + "', '" + DOCNO + "', cast(getdate() as smalldatetime), " +
                        "Right('0' + cast(DATEPART(hour, getdate()) as varchar), 2) + ':' + " +
                        "Right('0' + cast(DATEPART(minute, getdate()) as varchar), 2) + ':' + " +
                        "Right('0' + cast(DATEPART(second, getdate()) as varchar), 2) )");
  }

  function LogWRITE(DOCNO, DOC_TYPE)
  {
    AppendDDQS_LOG("WRITE", DOCNO, DOC_TYPE);
  }

  function LogREAD(DOCNO, DOC_TYPE)
  {
    AppendDDQS_LOG("READ", DOCNO, DOC_TYPE);
  }
%>
