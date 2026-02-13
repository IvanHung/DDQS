package tw.gov.ntak.ddqs.dao;

import tw.gov.ntak.ddqs.model.User;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDao {
    private final DataSource dataSource;

    public UserDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public User findEnabledUserForLogin(String userId, String password) throws SQLException {
        String sql = "select rowguid, user_id, user_name, user_role_id, user_enabled "
                + "from webap_user where upper(user_id)=upper(?) and user_password=? and user_enabled='Y'";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                User u = new User();
                u.setRowguid(rs.getString("rowguid"));
                u.setUserId(rs.getString("user_id"));
                u.setUserName(rs.getString("user_name"));
                u.setUserRoleId(rs.getString("user_role_id"));
                u.setUserEnabled(rs.getString("user_enabled"));
                return u;
            }
        }
    }
}
