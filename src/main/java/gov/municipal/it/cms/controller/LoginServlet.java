package gov.municipal.it.cms.controller;

import gov.municipal.it.cms.exception.LoginException;
import gov.municipal.it.cms.model.dao.UserDAO;
import gov.municipal.it.cms.model.pojo.User;
import gov.municipal.it.cms.model.pojo.UserRole;
import gov.municipal.it.cms.util.PasswordHashUtil;
import gov.municipal.it.cms.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private BasicDataSource dataSource;

    @Override
    public void init() {
        dataSource = (BasicDataSource) getServletContext().getAttribute("ds");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if ("logout".equals(action)) {
            session.removeAttribute("currentUser");
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usernameOrEmail = req.getParameter("usernameOrEmail");
        String password = req.getParameter("password");

        String contextPath = req.getContextPath();

        try {
            User currentUser = checkCredentials(usernameOrEmail, password);
            HttpSession session = req.getSession();
            session.setAttribute("currentUser", currentUser);
            System.out.println(currentUser.getId());

//            String location;
//
//            if(currentUser.getRole() == UserRole.ADMIN) {
//                location = contextPath + "/admin";
//            }else{
//                location = contextPath + "/employee";
//            }

            resp.sendRedirect(contextPath + "/dashboard");
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        } catch (LoginException e) {
            req.setAttribute("loginError", e.getMessage());
            req.getRequestDispatcher("/pages/login.jsp").forward(req, resp);
        }

    }

    private InputType isValid(String usernameOrEmail, String password) throws LoginException {
        if (usernameOrEmail != null && !usernameOrEmail.isEmpty() && password != null && !password.isEmpty()) {
            if(ValidationUtil.getInstance().isValid(ValidationUtil.RegexType.EMAIL, usernameOrEmail)) {
                return InputType.EMAIL;
            }else {
                return InputType.USERNAME;
            }
        }

        throw new LoginException("1001", "Input can not be empty");
    }

    private User checkCredentials(String username, String password) throws SQLException, ClassNotFoundException, LoginException {
        InputType type = isValid(username, password);

        boolean isEmail  = (type == InputType.EMAIL);

        UserDAO userDAO = new UserDAO(dataSource);

        Optional<User> optionalUser = userDAO.search(username, isEmail);
        if(optionalUser.isPresent()) {
            User user = optionalUser.get();

            boolean isUsername = isEmail ? username.equals(user.getEmail()) : username.equals(user.getUsername());
            boolean isPassword = PasswordHashUtil.checkPassword(password, user.getPassword());

            if(isUsername && isPassword){
                return user;
            }

            throw new LoginException("1000", "Invalid Credential.");
        }

        throw new LoginException("1001", "No user found with the entered credentials.");

    }

    enum InputType{
        USERNAME, EMAIL
    }

}
