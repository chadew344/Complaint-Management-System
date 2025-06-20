<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>CMS Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../css/style.css"><link>
    <style>
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 1.5rem;
        }

        .card-header {
            background: white;
            border-bottom: 1px solid #eee;
            font-weight: 500;
            padding: 1rem 1.5rem;
            border-radius: 10px 10px 0 0 !important;
        }

    </style>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-brand">
        <span>CMS</span>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-item">
            <a href="admin-dashboard.jsp" class="nav-link active">
                <i class="fas fa-home nav-icon"></i>
                <span>Dashboard</span>
            </a>
        </div>

        <div class="nav-item">
            <a href="complaint-page.jsp" class="nav-link">
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

<div class="topbar">
    <div class="topbar-brand">Complaint Management System</div>
    <div class="profile-circle">JD</div>
</div>

<div class="main-content">
    <div class="card">
        <div class="card-header">
            Recent Activity
        </div>
        <div class="card-body">
            <p>Welcome to your dashboard. Here you can manage all complaints and system settings.</p>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            Quick Actions
        </div>
        <div class="card-body">
            <div class="d-flex gap-3">
                <a href="complaint-page.jsp" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i> New Complaint
                </a>
                <button class="btn btn-outline-secondary">
                    <i class="fas fa-search me-2"></i> Search
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
    $(document).ready(function() {
        // Logout button functionality
        $('.btn-logout').click(function() {
            window.location.href = 'logout.jsp';
        });

        // Profile circle click
        $('.profile-circle').click(function() {
            window.location.href = 'profile.jsp';
        });

        // Active nav item highlighting
        $('.nav-link').click(function() {
            $('.nav-link').removeClass('active');
            $(this).addClass('active');
        });
    });
</script>
</body>
</html>