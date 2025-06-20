package gov.municipal.it.cms.controller;

import gov.municipal.it.cms.model.dao.UserDAO;
import gov.municipal.it.cms.model.pojo.User;
import gov.municipal.it.cms.model.pojo.UserRole;
import gov.municipal.it.cms.util.PasswordHashUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    BasicDataSource dataSource;

    @Override
    public void init() {
        dataSource = (BasicDataSource) getServletContext().getAttribute("ds");
    }
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = isLoggedIn(req, resp);

        if (user.getRole() != UserRole.ADMIN) {
            return;
        }


        try {
            List<User> users = new UserDAO(dataSource).getAll();

            System.out.println("Fetched users: " + users);

            req.setAttribute("users", users);

            req.getRequestDispatcher("/pages/user-manage.jsp").forward(req, resp);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/pages/login.jsp").forward(req, resp);
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

        if (action.equals("changePassword")) {
            changePassword(req, resp, user);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void changePassword(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        String currentPassword =  req.getParameter("currentPassword");
        String newPassword = req.getParameter("confirmPassword");

        String hashedPassword = PasswordHashUtil.hashPassword(newPassword);

        System.out.println("Current password: " + currentPassword);
        System.out.println("New password: " + newPassword);
        System.out.println("Hashed password: " + hashedPassword);

        try {
            new UserDAO(dataSource).changePassword(user.getId(), hashedPassword);

        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

    }
}
