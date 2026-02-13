package tw.gov.ntak.ddqs.web;

import tw.gov.ntak.ddqs.dao.AuditLogDao;
import tw.gov.ntak.ddqs.dao.DocumentDao;
import tw.gov.ntak.ddqs.model.Document;
import tw.gov.ntak.ddqs.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

@WebServlet(urlPatterns = {"/documents"})
public class DocumentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DocumentDao documentDao = (DocumentDao) getServletContext().getAttribute("documentDao");
        AuditLogDao auditLogDao = (AuditLogDao) getServletContext().getAttribute("auditLogDao");

        String docType = req.getParameter("docType");
        String docNo = req.getParameter("docNo");
        String idNo = req.getParameter("idNo");
        String keyword = req.getParameter("keyword");

        List<Document> list;
        try {
            list = documentDao.search(docType, docNo, idNo, keyword);
            User loginUser = (User) req.getSession().getAttribute("loginUser");
            if (loginUser != null && docNo != null && docNo.trim().length() > 0) {
                auditLogDao.insertReadLog(docType == null ? "" : docType, "READ", loginUser.getUserId(), docNo);
            }
        } catch (SQLException ex) {
            list = Collections.emptyList();
            req.setAttribute("error", ex.getMessage());
        }

        req.setAttribute("documents", list);
        req.getRequestDispatcher("/WEB-INF/views/documents.jsp").forward(req, resp);
    }
}
