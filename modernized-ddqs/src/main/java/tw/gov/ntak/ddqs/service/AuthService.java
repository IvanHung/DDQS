package tw.gov.ntak.ddqs.service;

import tw.gov.ntak.ddqs.dao.UserDao;
import tw.gov.ntak.ddqs.model.User;

import java.sql.SQLException;

public class AuthService {
    private final UserDao userDao;

    public AuthService(UserDao userDao) {
        this.userDao = userDao;
    }

    public User login(String userId, String password) throws SQLException {
        if (userId == null || password == null) {
            return null;
        }
        return userDao.findEnabledUserForLogin(userId.trim().toUpperCase(), password.trim());
    }
}
