# DDQS Modernized (Maven + Java 1.8 + Bootstrap/jQuery + MariaDB)

本目錄為 DDQS 改寫版本骨架，符合需求：

1. Maven 專案 (`pom.xml`)
2. Web 以 Bootstrap + jQuery
3. AP 以 Java 1.8 Servlet/JSP
4. DB 改為 MariaDB，且資料表名稱維持 DDQS 既有命名

## 1. 模組對應（舊系統 -> 新系統）

- 登入模組 (`login.asp`, `do_login.asp`) -> `LoginServlet`
- 文件查詢模組 (`pg1_1_1.asp`, `pg2_1_1.asp`, `pg3_1_1.asp`) -> `DocumentServlet`
- 審計 Log (`DDQS_LOG`) -> `AuditLogDao`
- DB 連線/共用函式 (`_dbctrl.asp`) -> `DataSourceProvider` + DAO

## 2. 目錄說明

- `src/main/java/.../web`：Servlet / Filter / Listener
- `src/main/java/.../dao`：資料存取層（MariaDB）
- `src/main/java/.../service`：商業邏輯層
- `src/main/webapp/WEB-INF/views`：JSP 畫面（Bootstrap + jQuery）
- `db/mariadb-ddqs-schema.sql`：MariaDB schema（保留原 table 名稱）

## 3. 執行方式

```bash
cd modernized-ddqs
mvn clean package
```

將產生 `target/ddqs-modernized.war`，可部署到 Tomcat 8.5/9。

## 4. 後續擴充建議

- 補齊 `pg1_1_2/pg2_1_2/pg3_1_2` 的新增、修改、刪除流程。
- 將 `sys_admin` 系列改寫成 RBAC 後台。
- 將原先 Word 轉檔服務（Delphi Service）改寫為 Java 排程/訊息佇列工作。
