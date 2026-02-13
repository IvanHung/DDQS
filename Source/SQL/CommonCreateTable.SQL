-- 共用 資料表建立SQL指令 --

-- for MS. SQL Server --

--**************************************************************************************************************
--**************************************************************************************************************
--** 更新日期 2002年6月28日
--**************************************************************************************************************
--**************************************************************************************************************

--** 代碼資料表 webap_code
--** 使用者資料表 webap_user
--** 權限資料表 webap_role

--**************************************************************************************************************
--**************************************************************************************************************
--**  共用定義
--**      自然人姓名/名稱                           name            varchar(12)
--**      法人名稱/公司名稱                         name            varchar(40)
--**      自然人統一編號/身分證統一編號             idn             varchar(10)
--**      法人統一編號/公司統一編號                 ban             varchar(8)
--**      地址                                      addr            varchar(120)
--**      日期                                      date            varchar(7)
--**      文號                                      doc_no          varchar(50)
--**      代碼                                      cd              varchar(12)
--**      傳真                                                      varchar(15)
--**      電子郵件                                  email           varchar(60)
--**      國籍                                      nationality     varchar(30)
--**      印製編號                                  print_serial_no varchar(8)
--**      是/否                                                     varchar(1)          'Y' or 'N'
--**      異動作業人員                              update_user     varchar(2)
--**      異動日期時間                              update_time     datetime
--**      紀錄編號                                  rowguid           uniqueidentifier    (GUID)
--**      登錄號碼                                  reg_serial_no   varchar(8)
--**************************************************************************************************************
--**************************************************************************************************************


--**************************************************************************************************************
--**************************************************************************************************************
--** 代碼資料表 webap_code
--**************************************************************************************************************
-- 以code_kind, code_id為主鍵

drop table webap_code;

create table webap_code
(
  code_kind varchar(12) not null default '0',                         -- 代碼類型
  code_id varchar(12) not null default '0',                           -- 代碼編號
  code_content varchar(120) not null default '未指定',                -- 代碼內容
  code_descript varchar(60),                                          -- 說明
  code_order int not null default 0,                                  -- 順序
  rowguid uniqueidentifier not null default newid()                     -- 紀錄編號
);

create unique index webap_code_uidx1 on webap_code (code_kind, code_id);

create index webap_code_idx1 on webap_code (code_kind, code_id, code_content, code_order);
create index webap_code_idx2 on webap_code (code_order);

create unique index webap_code_rowid on webap_code (rowguid);

grant select, insert, update, delete on webap_code to public;

insert into webap_code (code_kind, code_id, code_content) values ('0', '0', '代碼類別');
insert into webap_code (code_kind, code_id, code_content) values ('0', 'S0', '權限類別');
insert into webap_code (code_kind, code_id, code_content) values ('S0', '0', '系統管理員');
insert into webap_code (code_kind, code_id, code_content) values ('S0', '99', '應用系統測試員');


--**************************************************************************************************************
--**************************************************************************************************************
--** 使用者權限群組資料表 webap_userroles
--**************************************************************************************************************
-- 以user_id為主鍵

drop table webap_userroles;

create table webap_userroles
(
  uroles_user_rowguid uniqueidentifier not null,                      -- 使用者紀錄編號
  uroles_role_id varchar(6) not null,                                 -- 權限編號 (代碼S0)
  rowguid uniqueidentifier not null default newid()                   -- 紀錄編號
);

create unique index webap_userroles_rowid on webap_userroles (rowguid);

grant select, insert, update, delete on webap_user to public;


--**************************************************************************************************************
--**************************************************************************************************************
--** 使用者資料表 webap_user
--**************************************************************************************************************
-- 以user_id為主鍵

drop table webap_user;

create table webap_user
(
  user_id varchar(10) not null,                                       -- 登入系統用 使用者編號
  user_password varchar(10) not null,                                 -- 登入系統用 密碼
  user_name varchar(60) not null,                                     -- 登入者名稱 (姓名 公司名稱 暱稱等)
  user_idn varchar(12) not null,                                      -- 身分編號 (身分證統一編號 會員編號等)
  user_unit varchar(10) not null,                                     -- 單位
  user_role_id varchar(6) not null,                                   -- 權限編號 (代碼S0)
  user_enabled varchar(1) not null default 'N',                       -- 使用者有效 (是/否)
  user_last_login_ip varchar(15),                                     -- 上次登入IP位址
  user_last_login_success_time datetime,                              -- 上次登入成功時間
  user_last_login_fail_time datetime,                                 -- 上次失敗成功時間
  user_login_fail_count int default 0,                                -- 登入失敗次數
  user_create_date datetime not null default getdate(),               -- 建檔日期
  rowguid uniqueidentifier not null default newid()                     -- 紀錄編號
);

create unique index webap_user_uidx1 on webap_user (user_id);

create unique index webap_user_rowid on webap_user (rowguid);

grant select, insert, update, delete on webap_user to public;

insert into webap_user 
(user_id, user_password, user_name, user_idn, user_role_id, user_enabled) 
values ('SYSTEM', 'MANAGER', '預設系統管理員', 'SYSTEM', '0', 'Y');


--**************************************************************************************************************
--**************************************************************************************************************
--** 權限資料表 webap_role
--**************************************************************************************************************
-- 以role_id, role_page_filename為主鍵

drop table webap_role;

create table webap_role
(
  role_id varchar(6) not null,                                        -- 編號
  role_page_filename varchar(20) not null,                            -- 畫面檔案名稱
  rowguid uniqueidentifier not null default newid()                     -- 紀錄編號
);

create unique index webap_role_uidx1 on webap_role (role_id, role_page_filename);

create unique index webap_role_rowid on webap_role (rowguid);

grant select, insert, update, delete on webap_role to public;



--**************************************************************************************************************
--**************************************************************************************************************
--** 使用者瀏覽表 webap_user_view
--**************************************************************************************************************

drop view webap_user_view
go

create view webap_user_view
as
  select code_content user_role_name, user_role_id,
      dbo.GetSubRoles(webap_user.rowguid, user_role_id) user_subrole_names,
      user_id, user_idn, user_name, user_password, user_unit, SECTN_CHI_NM user_dept, user_enabled,
      user_last_login_ip, user_last_login_success_time, webap_user.rowguid
      from webap_user, webap_code, QICT105, QICT010
  where code_kind = 'S0'
  and user_role_id *= code_id
  and substring(user_id, 4, 5) *= EMPL_CD
  and QICT010.DIVISION_CD *= QICT105.DIVISION_CD
  and QICT010.ORG_CD + QICT010.SECTN_CD *= QICT105.ORG_SECTN
go
