package gov.municipal.it.cms.controller;

import gov.municipal.it.cms.model.dao.ComplaintDAO;
import gov.municipal.it.cms.model.pojo.Complaint;
import gov.municipal.it.cms.model.pojo.ComplaintStatus;
import gov.municipal.it.cms.model.pojo.User;
import gov.municipal.it.cms.model.pojo.UserRole;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard/*")
public class DashboardServlet extends HttpServlet {

    private BasicDataSource dataSource;

    @Override
    public void init() {
        dataSource = (BasicDataSource) getServletContext().getAttribute("ds");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("currentUser");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return;
        }

        populateCardStats(req, user);

        List<Complaint> recentComplaints = getRecentComplaints(user);
        req.setAttribute("recentComplaints", recentComplaints);
        req.setAttribute("welcomeName", nameTrim(user));

        if(user.getRole() == UserRole.ADMIN) {
            req.getRequestDispatcher("/pages/admin.jsp").forward(req, resp);
        }else{
            req.getRequestDispatcher("/pages/employee.jsp").forward(req, resp);
        }
    }

    private List<Complaint> getRecentComplaints(User currentUser) {
        try {
            return new ComplaintDAO(dataSource).getRecentComplaints(currentUser.getRole(), currentUser.getId());
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException("Failed to fetch recent complaints", e);
        }
    }

    private void populateCardStats(HttpServletRequest request, User currentUser) {
        try {
            Map<String, Integer> stats = new ComplaintDAO(dataSource).getComplaintCounts(currentUser.getRole(), currentUser.getId());

            request.setAttribute("total", stats.get("total"));
            request.setAttribute("pending", stats.get("pending"));
            request.setAttribute("in_progress", stats.get("in_progress"));
            request.setAttribute("resolved", stats.get("resolved"));
            request.setAttribute("closed", stats.get("closed"));
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException("Failed to fetch complaint stats", e);
        }
    }

    private String nameTrim(User currentUser) {
        String fullName = currentUser.getName();
        String[] nameParts = fullName.trim().split(" ");
        return nameParts[nameParts.length - 1];
    }
}
