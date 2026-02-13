package tw.gov.ntak.ddqs.web;

import tw.gov.ntak.ddqs.dao.AuditLogDao;
import tw.gov.ntak.ddqs.dao.DocumentDao;
import tw.gov.ntak.ddqs.dao.UserDao;
import tw.gov.ntak.ddqs.db.DataSourceProvider;
import tw.gov.ntak.ddqs.service.AuthService;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.sql.DataSource;

@WebListener
public class AppBootstrapListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        DataSource ds = DataSourceProvider.getDataSource();
        ServletContext ctx = sce.getServletContext();
        ctx.setAttribute("authService", new AuthService(new UserDao(ds)));
        ctx.setAttribute("documentDao", new DocumentDao(ds));
        ctx.setAttribute("auditLogDao", new AuditLogDao(ds));
    }
}
