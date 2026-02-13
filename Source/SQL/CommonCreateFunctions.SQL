-- 共用 自訂函式建立SQL指令 --

-- for MS. SQL Server --

--**************************************************************************************************************
--**************************************************************************************************************
--** 更新日期 2002年6月28日
--**************************************************************************************************************
--**************************************************************************************************************

--**************************************************************************************************************
--**************************************************************************************************************
--** 取出代碼資料 GetCode
--**************************************************************************************************************

DROP FUNCTION GetCode
GO

CREATE FUNCTION GetCode(@code_kind varchar(12), @code_id varchar(12))
RETURNS varchar(120)
AS
BEGIN 
  IF @code_id is null or @code_id = ''
    RETURN '[無]'
    
  DECLARE @ret varchar(120)

  SET @ret =
    (
      select top 1 code_content from webap_code
      where code_kind = @code_kind
      and code_id = @code_id
    )
    
  SET @ret = IsNull(@ret, '[無]')

  RETURN @code_id+'.'+@ret
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 取出使用者資料 GetUser
--**************************************************************************************************************

DROP FUNCTION GetUser
GO

CREATE FUNCTION GetUser(@user_rowguid uniqueidentifier)
RETURNS varchar(120)
AS
BEGIN 
  IF @user_rowguid is null
    RETURN '[無]'
    
  DECLARE @ret varchar(120)

  SET @ret =
    (
      select top 1 user_id+'.'+user_name user_name from webap_user
      where rowguid = @user_rowguid
    )
    
  SET @ret = IsNull(@ret, '[無]')

  RETURN @ret
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 取出次要權限資料 GetSubRoles
--**************************************************************************************************************

DROP FUNCTION GetSubRoles
GO

CREATE FUNCTION GetSubRoles(@user_rowguid uniqueidentifier, @else_role_id varchar(6))
RETURNS varchar(500)
AS
BEGIN
  IF @user_rowguid is null
    RETURN '[無]'

  DECLARE @ret varchar(500)

  DECLARE @role_name varchar(120)

  DECLARE subrole_cursor CURSOR FOR
  SELECT code_content role_name FROM webap_code, webap_userroles
  WHERE code_kind = 'S0'
  AND uroles_role_id <> @else_role_id
  AND uroles_role_id = code_id
  AND uroles_user_rowguid = @user_rowguid
  ORDER BY uroles_role_id

  OPEN subrole_cursor

  FETCH NEXT FROM subrole_cursor
  INTO @role_name
  
  SET @ret = ''

  WHILE @@FETCH_STATUS = 0
  BEGIN
    IF @ret = ''
      SET @ret = substring(@role_name, 1, 120)
    ELSE
      SET @ret = substring(@ret + '<br>' + @role_name, 1, 120)

    FETCH NEXT FROM subrole_cursor
    INTO @role_name
  END

  SET @ret = IsNull(@ret, '[無]')

  RETURN @ret
END
GO


--**************************************************************************************************************
--**************************************************************************************************************
--** 檢查是否為空字串 IsEmpty
--**************************************************************************************************************

DROP FUNCTION IsEmpty
GO

CREATE FUNCTION IsEmpty(@str varchar(120), @default varchar(120))
RETURNS varchar(120)
AS
BEGIN 
  IF @str is null or @str = ''
    RETURN @default
    
  RETURN @str
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 顯示民國年格式 ChDate
--**************************************************************************************************************

DROP FUNCTION ChDate
GO

CREATE FUNCTION ChDate(@datestr varchar(7))
RETURNS varchar(13)
AS
BEGIN 
  RETURN substring(@datestr, 2, 2) + '/' + substring(@datestr, 4, 2) + '/' + substring(@datestr, 6, 2)
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 轉換日期格式為7字元形式 ToDate7
--**************************************************************************************************************

DROP FUNCTION ToDate7
GO

CREATE FUNCTION ToDate7(@sd datetime)
RETURNS varchar(7)
AS
BEGIN
  RETURN right('00'+upper(year(@sd)-1911), 3) + right('0'+upper(month(@sd)), 2) + right('0'+upper(day(@sd)), 2)
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 轉換時間格式為6字元形式 ToTime
--**************************************************************************************************************

DROP FUNCTION ToTime
GO

CREATE FUNCTION ToTime(@sd datetime)
RETURNS varchar(6)
AS
BEGIN
  RETURN right('0'+upper(DATEPART(hour, @sd)), 2) + right('0'+upper(DATEPART(minute, @sd)), 2) + right('0'+upper(DATEPART(second, @sd)), 2)
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 轉換7字元形式為日期格式 ToDate
--**************************************************************************************************************

DROP FUNCTION ToDate
GO

CREATE FUNCTION ToDate(@sd varchar(7))
RETURNS datetime
AS
BEGIN
  DECLARE @ret datetime
  
  SET @ret = 0
  
  SET @ret = DATEADD(year, cast(substring(@sd, 1, 3) as numeric)+11, @ret)
  SET @ret = DATEADD(month, cast(substring(@sd, 4, 2) as numeric)-1, @ret)
  SET @ret = DATEADD(day, cast(substring(@sd, 6, 2) as numeric)-1, @ret)
  
  RETURN @ret
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 轉換布林格式為字元形式 ToYN
--**************************************************************************************************************

DROP FUNCTION ToYN
GO

CREATE FUNCTION ToYN(@yn varchar(1))
RETURNS varchar(2)
AS
BEGIN
  RETURN CASE @yn WHEN 'Y' THEN '是' ELSE '否' END
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 轉換字串為數值 ToInt
--**************************************************************************************************************

DROP FUNCTION ToInt
GO

CREATE FUNCTION ToInt(@str varchar(15))
RETURNS int
AS
BEGIN
  RETURN CASE isnumeric(IsNull(@str, '0')) WHEN 0 THEN 0 ELSE cast(@str as int) END
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 輸出日期表 ListDate
--**************************************************************************************************************

DROP FUNCTION ListDate
GO

CREATE FUNCTION ListDate(@start_date varchar(7), @end_date varchar(7))
RETURNS @retdate TABLE (s_date varchar(7), s_state varchar(4))
AS
BEGIN
  DECLARE @c_date datetime
  DECLARE @e_date datetime

  SET @c_date = dbo.to_date(@start_date)
  SET @e_date = dbo.to_date(@end_date)

  WHILE @c_date <= @e_date
  BEGIN
    insert into @retdate
    values (dbo.to_date7(@c_date), '')

    SET @c_date = DATEADD(Day, 1, @c_date)
  END

  RETURN
END
GO

--**************************************************************************************************************
--**************************************************************************************************************
--** 輸出日期表 ListHoliday
--**************************************************************************************************************

DROP FUNCTION ListHoliday
GO

CREATE FUNCTION ListHoliday(@start_date varchar(7), @end_date varchar(7))
RETURNS @retdate TABLE (s_date varchar(7), s_state varchar(4))
AS
BEGIN
  DECLARE @c_date datetime
  DECLARE @e_date datetime

  SET @c_date = dbo.to_date(@start_date)
  SET @e_date = dbo.to_date(@end_date)

  WHILE @c_date <= @e_date
  BEGIN
    IF DATEPART(weekday, @c_date) not in ('1', '7')
    BEGIN
      insert into @retdate
      values (dbo.to_date7(@c_date), '')
  
      SET @c_date = DATEADD(Day, 1, @c_date)
    END
  END

  RETURN
END
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

