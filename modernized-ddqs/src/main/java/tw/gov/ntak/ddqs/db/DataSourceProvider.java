package tw.gov.ntak.ddqs.db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import tw.gov.ntak.ddqs.config.AppConfig;

import javax.sql.DataSource;

public final class DataSourceProvider {
    private static final HikariDataSource DS = build();

    private DataSourceProvider() {
    }

    private static HikariDataSource build() {
        HikariConfig cfg = new HikariConfig();
        String jdbcUrl = "jdbc:mariadb://" + AppConfig.get("mariadb.host") + ":" + AppConfig.get("mariadb.port")
                + "/" + AppConfig.get("mariadb.database") + "?useUnicode=true&characterEncoding=UTF-8";
        cfg.setJdbcUrl(jdbcUrl);
        cfg.setUsername(AppConfig.get("mariadb.username"));
        cfg.setPassword(AppConfig.get("mariadb.password"));
        cfg.setMaximumPoolSize(AppConfig.getInt("mariadb.pool.max", 10));
        cfg.setPoolName("DDQS-MariaDB-Pool");
        return new HikariDataSource(cfg);
    }

    public static DataSource getDataSource() {
        return DS;
    }
}
