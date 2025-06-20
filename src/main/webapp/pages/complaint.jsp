<%@ page import="java.time.LocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <base href="${pageContext.request.contextPath}/">
    <title>Complaint</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><link>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-brand">
        <span>CMS</span>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-item">
            <a href="pages/employee-dashboard.jsp" class="nav-link">
                <i class="fas fa-home nav-icon"></i>
                <span>Dashboard</span>
            </a>
        </div>

        <div class="nav-item">
            <a href="pages/complaint-page.jsp" class="nav-link active">
                <i class="fas fa-ticket-alt nav-icon"></i>
                <span>Complaints</span>
            </a>
        </div>

        <div class="nav-item">
            <a href="#" class="nav-link">
                <i class="fas fa-users nav-icon"></i>
                <span>Users</span>
            </a>
        </div>

        <div class="nav-item">
            <a href="#" class="nav-link">
                <i class="fas fa-cog nav-icon"></i>
                <span>Settings</span>
            </a>
        </div>
    </nav>

    <div class="sidebar-footer">
        <button class="btn-logout">
            <i class="fas fa-sign-out-alt nav-icon"></i>
            <span>Logout</span>
        </button>
    </div>
</div>

<header class="topbar">
    <div class="topbar-brand">Complaint Management System</div>
    <div class="profile-circle">JD</div>
</header>

<main class="col-md-9 col-lg-10 main-content">
    <h2>Submit New Complaint</h2>

    <form action="complaint" method="post">
        <% String date = LocalDate.now().toString(); %>
        <input type="hidden" name="employeeId" value="${sessionScope.currentUser.username}" />

        <div class="mb-3">
            <label for="date" class="form-label">Date</label>
            <input
                    type="text"
                    class="form-control-plaintext"
                    id="date"
                    value="<%= date %>"
                    readonly
            />
        </div>
        <div class="mb-3">
            <label for="subject" class="form-label">Subject</label>
            <input type="text" class="form-control" id="subject" name="subject"
                   value="${complaint.subject}" required>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">Description</label>
            <textarea class="form-control" id="description" name="description"
                      rows="15" required>${complaint.description}</textarea>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-${messageType eq 'success' ? 'primary' : 'danger'} mb-3">
                <strong>${messageType eq 'success' ? 'Success: ' : 'Error: '}</strong>${message}
            </div>
        </c:if>

        <button type="submit" class="btn btn-primary">Submit Complaint</button>
        <a href="${pageContext.request.contextPath}/pages/employee-dashboard.jsp"
           class="btn btn-outline-secondary">Cancel</a>
    </form>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</body>
</html>
