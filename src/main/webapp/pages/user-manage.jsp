<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <base href="${pageContext.request.contextPath}/" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>CMS Complaints</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link rel="stylesheet" href="css/style-pages.css" />
  </head>
  <body class="app-container">
  <%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

    if(session.getAttribute("currentUser") == null){
      response.sendRedirect(request.getContextPath() + "/pages/login.jsp"); }

  %>
    <header class="topbar">
      <div class="d-flex align-items-center">
        <button class="sidebar-toggle me-3 d-lg-none">
          <i class="fa-solid fa-bars"></i>
        </button>
        <div class="topbar-brand fw-bold">
          <a class="navbar-brand" style="color: #1e3c72" href="#">
            <i class="fas fa-city me-2"></i>Municipal CMS
          </a>
        </div>
      </div>
      <div class="d-flex align-items-center gap-3">
        <div class="text-end d-none d-sm-block">
          <div class="fw-semibold text-capitalize">
            ${currentUser.getName()}
          </div>
          <div class="small text-muted text-capitalize">
            ${currentUser.getRole().getDbValue()}
          </div>
        </div>
        <div class="profile-dropdown">
          <div class="profile-circle" id="profileDropdown">JD</div>
          <div class="profile-dropdown-menu" id="dropdownMenu">
            <a
              href="#"
              class="profile-dropdown-item"
              data-bs-toggle="modal"
              data-bs-target="#profileViewModal"
            >
              <i class="bi bi-person"></i> Profile
            </a>
            <a
              href="#"
              class="profile-dropdown-item"
              data-bs-toggle="modal"
              data-bs-target="#passwordChangeModal"
            >
              <i class="bi bi-gear"></i> Settings
            </a>
            <div class="profile-dropdown-divider"></div>
            <a
              href="#"
              class="profile-dropdown-item"
              data-bs-toggle="modal"
              data-bs-target="#logoutModal"
            >
              <i class="bi bi-box-arrow-right"></i> Logout
            </a>
          </div>
        </div>
      </div>
    </header>

    <div class="content-wrapper">
      <aside class="sidebar">
        <div
          class="d-flex justify-content-between align-items-center px-3 mb-4"
        >
          <span class="fw-bold nav-link-text">Menu</span>
        </div>

        <nav class="sidebar-nav">
          <a href="dashboard/" class="nav-link">
            <i class="fas fa-th-large"></i>
            <span class="nav-link-text">Dashboard</span>
          </a>

          <a href="pages/complaint-page.jsp" class="nav-link">
            <i class="fa-solid fa-file-invoice"></i>
            <span class="nav-link-text">Complaints</span>
          </a>

          <a href="user" class="nav-link active">
            <i class="bi bi-people"></i>
            <span class="nav-link-text">Users</span>
          </a>

          <a
            href="#"
            class="nav-link"
            data-bs-toggle="modal"
            data-bs-target="#passwordChangeModal"
          >
            <i class="bi bi-gear"></i>
            <span class="nav-link-text">Settings</span>
          </a>
        </nav>

        <div class="mt-auto px-3">
          <a
            href="#"
            class="nav-link"
            data-bs-toggle="modal"
            data-bs-target="#logoutModal"
          >
            <i class="bi bi-box-arrow-right"></i>
            <span class="nav-link-text">Logout</span>
          </a>
        </div>
      </aside>

      <main class="main-content">
        <div class="container-fluid">
          <div
            class="d-flex justify-content-between align-items-center mt-3 mb-md-5"
          >
            <div>
              <h3 class="fw-bold">User Management</h3>
            </div>
            <button
              class="btn btn-primary"
              data-bs-toggle="modal"
              data-bs-target="#addUserModal"
            >
              <i class="bi bi-plus-circle me-2"></i> Add New User
            </button>

          </div>

          <div class="container mt-5">
            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>

            <table class="table mt-3">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Username</th>
                  <th>Email</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${empty users}">
                    <tr>
                      <td colspan="4" class="text-center">No users found</td>
                    </tr>
                  </c:when>
                  <c:otherwise>
                    <c:forEach items="${users}" var="user">
                      <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>
                          <a href="#" class="btn btn-sm btn-warning">Edit</a>
                          <a href="#" class="btn btn-sm btn-danger">Delete</a>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>

            <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <form id="addUserForm">
                      <div class="mb-3">
                        <label for="userName" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="userName" name="name" required>
                        <div class="invalid-feedback">Please provide a valid name.</div>
                      </div>

                      <div class="mb-3">
                        <label for="userEmail" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="userEmail" name="email" required>
                        <div class="invalid-feedback">Please provide a valid email.</div>
                      </div>

<%--                      <div class="mb-3">--%>
<%--                        <label for="username" class="form-label">Username</label>--%>
<%--                        <input type="text" class="form-control" id="username" name="username" required>--%>
<%--                        <div class="invalid-feedback">Please choose a username.</div>--%>
<%--                      </div>--%>

                      <div class="mb-3">
                        <label for="userRole" class="form-label">Role</label>
                        <select class="form-select" id="userRole" name="role" required>
                          <option value="" selected disabled>Select role</option>
                          <option value="ADMIN">Admin</option>
                          <option value="EMPLOYEE">Employee</option>
                        </select>
                        <div class="invalid-feedback">Please select a role.</div>
                      </div>

<%--                      <div class="mb-3">--%>
<%--                        <label for="userPassword" class="form-label">Password</label>--%>
<%--                        <div class="input-group">--%>
<%--                          <input type="password" class="form-control" id="userPassword" name="password" required>--%>
<%--                          <button class="btn btn-outline-secondary toggle-password" type="button">--%>
<%--                            <i class="bi bi-eye"></i>--%>
<%--                          </button>--%>
<%--                        </div>--%>
<%--                        <div class="invalid-feedback">Please provide a password.</div>--%>
<%--                      </div>--%>

<%--                      <div class="mb-3">--%>
<%--                        <label for="confirmPassword" class="form-label">Confirm Password</label>--%>
<%--                        <div class="input-group">--%>
<%--                          <input type="password" class="form-control" id="confirmPassword" required>--%>
<%--                          <button class="btn btn-outline-secondary toggle-password" type="button">--%>
<%--                            <i class="bi bi-eye"></i>--%>
<%--                          </button>--%>
<%--                        </div>--%>
<%--                        <div class="invalid-feedback" id="passwordMatchError">Passwords do not match.</div>--%>
<%--                      </div>--%>
                    </form>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveUserBtn">Save User</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>

    <div
      class="modal fade"
      id="profileViewModal"
      tabindex="-1"
      aria-labelledby="profileViewModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="profileViewModalLabel">User Profile</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div class="text-center mb-4">
              <div class="profile-circle-lg mb-3">JD</div>
              <h5 class="mb-1">${currentUser.getName()}</h5>
              <span class="badge bg-primary">${currentUser.getRole()}</span>
            </div>

            <div class="profile-details">
              <div class="detail-item">
                <span class="detail-label"
                ><i class="bi bi-person me-2"></i>Username:</span
                >
                <span class="detail-value"> ${currentUser.getUsername()}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label"
                ><i class="bi bi-envelope me-2"></i>Email:</span
                >
                <span class="detail-value">${currentUser.getEmail()}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label"
                ><i class="bi bi-shield me-2"></i>Role:</span
                >

                <span class="detail-value">${currentUser.getRole() == UserRole.ADMIN ? "Admin" : "Employee"}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label"
                ><i class="bi bi-calendar me-2"></i>Active Since:</span
                >
                <span class="detail-value">January 15, 2022</span>
              </div>
              <div class="detail-item">
                <span class="detail-label"
                ><i class="bi bi-clock-history me-2"></i>Last Login:</span
                >
                <span class="detail-value">Today, 10:45 AM</span>
              </div>
            </div>
          </div>
          <div class="modal-footer justify-content-center">
            <button
              type="button"
              class="btn btn-primary"
              data-bs-dismiss="modal"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>

    <div
      class="modal fade"
      id="passwordChangeModal"
      tabindex="-1"
      aria-labelledby="passwordChangeModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="passwordChangeModalLabel">
              Change Password
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form id="passwordChangeForm">
              <div class="mb-3">
                <label for="currentPassword" class="form-label"
                  >Current Password</label
                >
                <div class="input-group">
                  <input
                    type="password"
                    class="form-control"
                    id="currentPassword"
                    required
                  />
                  <button
                    class="btn btn-outline-secondary toggle-password"
                    type="button"
                  >
                    <i class="bi bi-eye"></i>
                  </button>
                </div>
              </div>
              <div class="mb-3">
                <label for="newPassword" class="form-label">New Password</label>
                <div class="input-group">
                  <input
                    type="password"
                    class="form-control"
                    id="newPassword"
                    required
                  />
                  <button
                    class="btn btn-outline-secondary toggle-password"
                    type="button"
                  >
                    <i class="bi bi-eye"></i>
                  </button>
                </div>
                <div class="password-strength mt-2">
                  <div class="progress" style="height: 5px">
                    <div
                      class="progress-bar"
                      role="progressbar"
                      style="width: 0%"
                    ></div>
                  </div>
                  <small class="text-muted password-strength-text"
                    >Password strength: weak</small
                  >
                </div>
              </div>
              <div class="mb-3">
                <label for="confirmPassword" class="form-label"
                  >Confirm New Password</label
                >
                <div class="input-group">
                  <input
                    type="password"
                    class="form-control"
                    id="confirmPassword"
                    required
                  />
                  <button
                    class="btn btn-outline-secondary toggle-password"
                    type="button"
                  >
                    <i class="bi bi-eye"></i>
                  </button>
                </div>
                <div class="invalid-feedback" id="passwordMatchError">
                  Passwords do not match
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancel
            </button>
            <button type="button" class="btn btn-primary" id="savePasswordBtn">
              Save Changes
            </button>
          </div>
        </div>
      </div>
    </div>

    <div
      class="modal fade"
      id="logoutModal"
      tabindex="-1"
      aria-labelledby="logoutModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="logoutModalLabel">Confirm Logout</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <p>Are you sure you want to logout?</p>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancel
            </button>
            <a href="login?action=logout" class="btn btn-danger">Logout</a>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="js/script.js"></script>
  </body>
</html>
