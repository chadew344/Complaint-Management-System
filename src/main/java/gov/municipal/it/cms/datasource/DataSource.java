package gov.municipal.it.cms.datasource;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.SQLException;

@WebListener
public class DataSource implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        dataSourceConfig(sce);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            ServletContext context = sce.getServletContext();
            BasicDataSource dataSource = (BasicDataSource) context.getAttribute("db");
            dataSource.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void dataSourceConfig(ServletContextEvent sce){

        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost:3306/complaint_management");
        ds.setUsername("root");
        ds.setPassword("Ijse@1234");
        ds.setInitialSize(5);
        ds.setMaxTotal(20);

        ServletContext servletContext = sce.getServletContext();
        servletContext.setAttribute("ds", ds);


    }
}
