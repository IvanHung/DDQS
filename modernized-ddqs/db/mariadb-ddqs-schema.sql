-- DDQS MariaDB schema (table names preserved)
-- NOTE: This script keeps original logical table names from DDQS.

create table if not exists webap_code (
  code_kind varchar(12) not null,
  code_id varchar(12) not null,
  code_content varchar(120) not null,
  code_descript varchar(60),
  code_order int not null default 0,
  rowguid char(36) not null,
  primary key (code_kind, code_id),
  unique key uk_webap_code_rowguid (rowguid)
) engine=InnoDB default charset=utf8mb4;

create table if not exists webap_user (
  user_id varchar(10) not null,
  user_password varchar(60) not null,
  user_name varchar(60) not null,
  user_role_id varchar(6) not null,
  user_idn varchar(10),
  user_enabled varchar(1) not null default 'Y',
  user_last_login_ip varchar(60),
  user_last_login_success_time datetime,
  user_last_login_fail_time datetime,
  user_login_fail_count int default 0,
  rowguid char(36) not null,
  primary key (user_id),
  unique key uk_webap_user_rowguid (rowguid)
) engine=InnoDB default charset=utf8mb4;

create table if not exists webap_role (
  role_id varchar(6) not null,
  role_page_filename varchar(120) not null,
  rowguid char(36) not null,
  primary key (role_id, role_page_filename),
  unique key uk_webap_role_rowguid (rowguid)
) engine=InnoDB default charset=utf8mb4;

create table if not exists webap_userroles (
  uroles_user_rowguid char(36) not null,
  uroles_role_id varchar(6) not null,
  rowguid char(36) not null,
  primary key (uroles_user_rowguid, uroles_role_id),
  unique key uk_webap_userroles_rowguid (rowguid)
) engine=InnoDB default charset=utf8mb4;

create table if not exists DDQS_INDEX1 (
  rowguid char(36) not null,
  INDEX1 varchar(120) not null,
  primary key (rowguid)
) engine=InnoDB default charset=utf8mb4;

create table if not exists DDQS_INDEX2 (
  rowguid char(36) not null,
  INDEX1_rowguid char(36) not null,
  INDEX2 varchar(120) not null,
  primary key (rowguid),
  key idx_ddqs_index2_1 (INDEX1_rowguid)
) engine=InnoDB default charset=utf8mb4;

create table if not exists DDQS_KEYS (
  rowguid char(36) not null,
  INDEX2_rowguid char(36) not null,
  KEYS varchar(120) not null,
  primary key (rowguid),
  key idx_ddqs_keys_1 (INDEX2_rowguid)
) engine=InnoDB default charset=utf8mb4;

create table if not exists DDQS_DOC (
  rowguid char(36) not null,
  DOC_TYPE varchar(1) not null,
  DOCNO varchar(50),
  SEND_DATE varchar(10),
  IDNO varchar(12),
  INDEX1_idx char(36),
  INDEX2_LIST text,
  KEY_LIST text,
  DOC longtext,
  primary key (rowguid),
  key idx_ddqs_doc_type (DOC_TYPE),
  key idx_ddqs_doc_docno (DOCNO),
  key idx_ddqs_doc_index1 (INDEX1_idx)
) engine=InnoDB default charset=utf8mb4;

create table if not exists DDQS_LOG (
  DOC_TYPE varchar(1) not null,
  ACCESS_REC varchar(10) not null,
  USER_ID varchar(10) not null,
  DOCNO varchar(50),
  EDATE date,
  ETIME varchar(8)
) engine=InnoDB default charset=utf8mb4;
