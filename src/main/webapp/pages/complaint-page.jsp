<%@ page import="gov.municipal.it.cms.model.pojo.User" %>
<%@ page import="gov.municipal.it.cms.model.pojo.UserRole" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <% User user = (User) session.getAttribute("currentUser");%>
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

          <a href="pages/complaint-page.jsp" class="nav-link active">
            <i class="fa-solid fa-file-invoice"></i>
            <span class="nav-link-text">Complaints</span>
          </a>

            <% if (user.getRole() == UserRole.ADMIN) { %>
          <a href="pages/user-manage.jsp" class="nav-link">
            <i class="bi bi-people"></i>
            <span class="nav-link-text">Users</span>
          </a>
          <% }%>

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
              <h3 class="fw-bold">Complaints</h3>
            </div>
          </div>

          <div class="card mb-4 border-0 shadow-sm">
            <div
              class="card-header d-flex justify-content-between align-items-center py-3 bg-white"
            >
              <h6 class="m-0 font-weight-bold">All Complaints</h6>
              <div class="d-flex gap-2">
                <div class="search-box">
                  <i class="bi bi-search"></i>
                  <input
                    type="text"
                    class="form-control form-control-sm"
                    placeholder="Search complaints..."
                  />
                </div>
                <button class="btn btn-sm btn-outline-secondary">
                  <i class="bi bi-funnel me-1"></i> Filter
                </button>
              </div>
            </div>
            <div class="card-body p-0">
              <div class="table-responsive">
                <table class="table table-hover mb-0">
                  <thead class="table-light">
                  <tr>
                    <th>ID</th>
                    <th>SUBJECT</th>
                    <th>SUBMITTED AT</th>
                    <th>PRIORITY</th>
                    <th>STATUS</th>
                    <th>Actions</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                    <c:when test="${not empty allComplaints}">
                      <c:forEach var="complaint" items="${allComplaints}">
                        <tr>
                          <td>${complaint.complaintId}</td>
                          <td>${complaint.subject}</td>
                          <td class="date-cell">${complaint.submittedAt}</td>
                          <td>
                            <c:choose>
                              <c:when test="${complaint.priority == 'LOW'}">
                                <span class="badge-status badge-low">LOW</span>
                              </c:when>
                              <c:when test="${complaint.priority == 'MEDIUM'}">
                                <span class="badge-status badge-medium">MEDIUM</span>
                              </c:when>
                              <c:when test="${complaint.priority == 'HIGH'}">
                                <span class="badge-status badge-high">HIGH</span>
                              </c:when>
                              <c:otherwise>
                                <span class="badge-status">${complaint.priority}</span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <c:choose>
                              <c:when
                                      test="${complaint.complaintStatus == 'PENDING'}"
                              >
                              <span class="badge-status badge-pending">
                                <i class="bi bi-clock-fill me-1"></i> PENDING
                              </span>
                              </c:when>
                              <c:when
                                      test="${complaint.complaintStatus == 'IN_PROGRESS'}"
                              >
                              <span class="badge-status badge-in_progress">
                                <i class="bi bi-gear-fill me-1"></i> IN PROGRESS
                              </span>
                              </c:when>
                              <c:when
                                      test="${complaint.complaintStatus == 'RESOLVED'}"
                              >
                              <span class="badge-status badge-resolved">
                                <i class="bi bi-check-circle-fill me-1"></i>
                                RESOLVED
                              </span>
                              </c:when>
                              <c:when
                                      test="${complaint.complaintStatus == 'CLOSED'}"
                              >
                              <span class="badge-status badge-closed">
                                <i class="bi bi-archive-fill me-1"></i> CLOSED
                              </span>
                              </c:when>
                              <c:otherwise>
                              <span class="badge-status">
                                  ${complaint.complaintStatus}
                              </span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <button
                                    class="btn btn-sm btn-info view-btn"
                                    data-id="${complaint.complaintId}"
                                    data-bs-toggle="modal"
                                    data-bs-target="#complaintModal"
                            >
                              <i class="bi bi-eye"></i>
                            </button>

                            <button
                                    class="btn btn-sm btn-warning edit-btn"
                                    data-id="${complaint.complaintId}"
                                    data-bs-toggle="modal"
                                    data-bs-target="#complaintModal"
                            >
                              <i class="bi bi-pencil"></i>
                            </button>

                            <button
                                    class="btn btn-sm btn-danger delete-btn"
                                    data-id="${complaint.complaintId}"
                            >
                              <i class="bi bi-trash"></i>
                            </button>
                          </td>
                        </tr>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <tr>
                        <td colspan="6" class="text-center">No data found</td>
                      </tr>
                    </c:otherwise>
                  </c:choose>
                  </tbody>
                </table>
              </div>

              <div
                class="p-3 d-flex justify-content-around align-items-start bg-white"
              >
                <div class="text-muted small">
                  Showing <span class="fw-semibold">1</span> to
                  <span class="fw-semibold">1</span> of
                  <span class="fw-semibold">${allComplaints.size()}</span> entries
                </div>
                <nav aria-label="Page navigation">
                  <ul class="pagination mb-0">
                    <li class="page-item disabled">
                      <a class="page-link" href="#" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                      </a>
                    </li>
                    <li class="page-item active">
                      <a class="page-link" href="#">1</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#">2</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#">3</a>
                    </li>
                    <li class="page-item">
                      <a class="page-link" href="#" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                      </a>
                    </li>
                  </ul>
                </nav>
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
    <script >
      $(document).ready(function() {
        $('.date-cell').each(function() {
          const rawDate = $(this).text();
          if (rawDate) {
            const formattedDate = rawDate.replace('T', ' ').replace(/\..+/, '');
            $(this).text(formattedDate);
          }
        });
      });
    </script>
  </body>
</html>
