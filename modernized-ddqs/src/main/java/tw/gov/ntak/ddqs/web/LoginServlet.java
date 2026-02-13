package tw.gov.ntak.ddqs.web;

import tw.gov.ntak.ddqs.model.User;
import tw.gov.ntak.ddqs.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AuthService authService = (AuthService) getServletContext().getAttribute("authService");
        String userId = req.getParameter("userId");
        String password = req.getParameter("password");

        try {
            User user = authService.login(userId, password);
            if (user == null) {
                req.setAttribute("error", "帳號或密碼錯誤，或使用者已停用。");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("loginUser", user);
            resp.sendRedirect(req.getContextPath() + "/documents");
        } catch (SQLException ex) {
            throw new ServletException("Login failed", ex);
        }
    }
}
