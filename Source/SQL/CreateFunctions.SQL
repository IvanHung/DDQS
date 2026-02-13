--**************************************************************************************************************
--**************************************************************************************************************
--** 取出使用者資料(區分單位與權限) GetUserByUnitRole
--**************************************************************************************************************

DROP FUNCTION GetUserByUnitRole
GO

CREATE FUNCTION GetUserByUnitRole(@dept_id varchar(10), @role_id varchar(10))
RETURNS TABLE
AS
RETURN (
  select EMPCD, DEPTNM + ' ' + USERNM USERNM
  from EMPL_VIEW
  left join webap_user
  on substring(webap_user.user_id, 4, 5) = EMPCD
  left join webap_userroles
  on webap_userroles.uroles_user_rowguid = webap_user.rowguid
  where DEPTID=@dept_id
  and (user_role_id=@role_id or webap_userroles.uroles_role_id=@role_id)
  group by EMPCD, DEPTNM + ' ' + USERNM
)
GO


--**************************************************************************************************************
--**************************************************************************************************************
--** 取出日期字串 GetChDateStr
--**************************************************************************************************************

DROP FUNCTION GetChDateStr
GO

CREATE FUNCTION GetChDateStr(@d1 datetime)
RETURNS varchar(120)
AS
BEGIN
  IF @d1 is null
    RETURN ''

  DECLARE @ret varchar(120)

  SET @ret =
    right('000' + upper(YEAR(@d1)-1911), 3) + '年' + right('00' + upper(MONTH(@d1)), 2) + '月' + right('00' + upper(DAY(@d1)), 2) + '日'

  RETURN @ret
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 取出單位名稱 GetDeptName
--**************************************************************************************************************

DROP FUNCTION GetDeptName
GO

CREATE FUNCTION GetDeptName(@dept varchar(10))
RETURNS varchar(120)
AS
BEGIN
  IF @dept is null
    RETURN ''

  DECLARE @ret varchar(120)

  SET @ret =
    (
      select top 1 DEPTNM from DEPT_VIEW
      where DEPTID = @dept
    )

  RETURN IsNull(@ret, '[無]')
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 取出單位員工名稱 GetDeptEmpName
--**************************************************************************************************************

DROP FUNCTION GetDeptEmpName
GO

CREATE FUNCTION GetDeptEmpName(@empl varchar(10))
RETURNS varchar(120)
AS
BEGIN
  IF @empl is null
    RETURN ''

  DECLARE @ret varchar(120)

  SET @ret =
    (
      select top 1 DEPTNM + ' ' + USERNM from EMPL_VIEW
      where EMPCD = @empl or USERID = @empl
    )

  RETURN IsNull(@ret, '[無]')
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 取出完整員工編號 GetFullEmpID
--**************************************************************************************************************

DROP FUNCTION GetFullEmpID
GO

CREATE FUNCTION GetFullEmpID(@empl varchar(10))
RETURNS varchar(120)
AS
BEGIN
  IF @empl is null
    RETURN ''

  DECLARE @ret varchar(120)

  SET @ret =
    (
      select top 1 USERID from EMPL_VIEW
      where EMPCD = @empl or USERID = @empl
    )

  RETURN IsNull(@ret, '[無]')
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 取出員工名稱 GetEmpName
--**************************************************************************************************************

DROP FUNCTION GetEmpName
GO

CREATE FUNCTION GetEmpName(@empl varchar(10))
RETURNS varchar(120)
AS
BEGIN
  IF @empl is null
    RETURN ''

  DECLARE @ret varchar(120)

  SET @ret =
    (
      select top 1 USERNM from EMPL_VIEW
      where EMPCD = @empl or USERID = @empl
    )

  RETURN IsNull(@ret, '[無]')
END
GO

