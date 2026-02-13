package tw.gov.ntak.ddqs.dao;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;

public class AuditLogDao {
    private final DataSource dataSource;

    public AuditLogDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void insertReadLog(String docType, String rec, String userId, String docNo) throws SQLException {
        String sql = "insert into DDQS_LOG (DOC_TYPE, ACCESS_REC, USER_ID, DOCNO, EDATE, ETIME) values (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, docType);
            ps.setString(2, rec);
            ps.setString(3, userId);
            ps.setString(4, docNo);
            ps.setDate(5, java.sql.Date.valueOf(LocalDate.now()));
            ps.setString(6, LocalTime.now().withNano(0).toString());
            ps.executeUpdate();
        }
    }
}
