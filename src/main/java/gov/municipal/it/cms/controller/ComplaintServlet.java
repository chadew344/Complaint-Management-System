package gov.municipal.it.cms.controller;

import gov.municipal.it.cms.model.dao.ComplaintDAO;
import gov.municipal.it.cms.model.pojo.*;
import gov.municipal.it.cms.util.ComplaintIdGenerator;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {
    BasicDataSource dataSource;

    @Override
    public void init() {
        dataSource = (BasicDataSource) getServletContext().getAttribute("ds");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        User user = isLoggedIn(req, resp);

        if (user == null) {
            return;
        }

        UserRole role = user.getRole();

        if ("view".equals(action) || "edit".equals(action)) {
            String id = req.getParameter("id");
            System.out.println("ComplaintServlet.doGet(): " + id);
            try {
                ComplaintDAO dao = new ComplaintDAO(dataSource);
                Optional<Complaint> optionalComplaint = dao.searchById(id);

                if (optionalComplaint.isPresent()) {
                    Complaint complaint = optionalComplaint.get();
                    req.setAttribute("complaint", complaint);
                    req.setAttribute("mode", action); // "view" or "edit"
                    req.getRequestDispatcher("/pages/complaint.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
                }
            } catch (SQLException | ClassNotFoundException e) {
                throw new ServletException("Database error", e);
            }
        }else if ("delete".equals(action)) {
            deleteComplaint(req, resp);
        } else if ("get".equals(action)) {
            getAllComplaints(req, resp, user);
        }
    }

    private User isLoggedIn(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }

        return user;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        User user = isLoggedIn(req, resp);

        if (user == null) {
            return;
        }

        switch (action) {
            case "create" -> createComplaint(req, resp, user);
            case "update" -> updateComplaint(req, resp, user);
            case "delete" -> deleteComplaint(req, resp);
            default ->
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void createComplaint(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws ServletException, IOException {
        Complaint complaint = new Complaint();
        complaint.setSubject(req.getParameter("subject"));
        complaint.setDescription(req.getParameter("description"));
        complaint.setPriority(PriorityType.fromDbValue(req.getParameter("priority")));
        complaint.setEmployeeId(currentUser.getId());

        try {
            if(saveComplaint(complaint)) {
                req.getSession().setAttribute("message", "Complaint " +complaint.getComplaintId()+" submitted successfully!");
                req.getSession().setAttribute("messageType", "success");
            } else {
                req.getSession().setAttribute("message", "Failed to submit complaint");
                req.getSession().setAttribute("messageType", "error");
            }
        } catch (SQLException | ClassNotFoundException e) {
            req.getSession().setAttribute("message", "Error: " + e.getMessage());
            req.getSession().setAttribute("messageType", "error");
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/pages/complaint.jsp");
    }

    private boolean saveComplaint(Complaint complaint) throws SQLException, ClassNotFoundException {
        if(complaint.getSubject() == null || complaint.getSubject().isEmpty() ||
                complaint.getDescription() == null || complaint.getDescription().isEmpty()) {
            return false;
        }

        complaint.setComplaintStatus(ComplaintStatus.PENDING);
        complaint.setSubmittedAt(LocalDateTime.now());
        complaint.setComplaintId(ComplaintIdGenerator.generateComplaintId());

        ComplaintDAO complaintDAO = new ComplaintDAO(dataSource);
        return complaintDAO.save(complaint);
    }

    private void updateComplaint(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        Complaint complaint = new Complaint();
        String complaintId = req.getParameter("id");

        switch (user.getRole()) {
            case EMPLOYEE ->{
                complaint.setSubject(req.getParameter("subject"));
                complaint.setDescription(req.getParameter("description"));
            }
            case ADMIN ->  {
                complaint.setAdminRemark(req.getParameter("adminRemarks"));
                complaint.setComplaintStatus(ComplaintStatus.fromDbValue(req.getParameter("status")));
                complaint.setAdminRemarkedAt(LocalDateTime.now());
            }
        }

        complaint.setPriority(PriorityType.fromDbValue(req.getParameter("priority")));
        complaint.setComplaintId(complaintId);

        try {
            boolean isUpdated = new ComplaintDAO(dataSource).updateComplaintByUserRole(complaint, user.getRole());
            if(isUpdated) {
                req.getSession().setAttribute("message", "Complaint " +complaintId+" updated successfully!");
                req.getSession().setAttribute("messageType", "success");
            } else {
                req.getSession().setAttribute("message", "Failed to update complaint");
                req.getSession().setAttribute("messageType", "error");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("message", "Error: " + e.getMessage());
            req.getSession().setAttribute("messageType", "error");
            e.printStackTrace();
        }

        resp.sendRedirect("complaint?action=view&id=" + complaintId);

    }

    private void deleteComplaint(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        try {
            Boolean isDelete = new ComplaintDAO(dataSource).delete(id);
            resp.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    private void getAllComplaints(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        try {
            List<Complaint> allComplaints = new ComplaintDAO(dataSource).getAllRoleWise(user.getRole(), user.getId());
            req.setAttribute("allComplaints", allComplaints);

            System.out.println("All complaints in get controler page" +allComplaints.size());
            req.getRequestDispatcher("/pages/complaint-page.jsp").forward(req, resp);
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }
}
