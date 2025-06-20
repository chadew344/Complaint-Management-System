<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="gov.municipal.it.cms.model.pojo.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
  String mode = (String) request.getAttribute("mode");
  if (mode == null) {
    mode = request.getParameter("mode");
    if (mode == null) {
      mode = "create"; // default mode
    }
  }
  boolean isViewMode = "view".equals(mode);
  boolean isEditMode = "edit".equals(mode);
  System.out.println("MODE: " +mode + "\n isViewMode: " +isViewMode+ "\n isEditMode: " +isEditMode);

  User user = (User) session.getAttribute("currentUser");
  boolean isAdmin = false;
  if(user.getRole() == UserRole.ADMIN){
      isAdmin = true;
  }

  System.out.println("Is admin: " +isAdmin);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <base href="${pageContext.request.contextPath}/" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><%= mode.substring(0, 1).toUpperCase() + mode.substring(1) %> Complaint %></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" />
  <link rel="stylesheet" href="css/form-style.css" />
</head>
<body>
<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

  if(session.getAttribute("currentUser") == null){
    response.sendRedirect(request.getContextPath() + "/pages/login.jsp"); }

%>
<div class="form-container">
  <div class="form-header">
    <h5 class="form-title"><%= mode.substring(0, 1).toUpperCase() + mode.substring(1) %> Complaint</h5>
    <p class="text-muted mb-0">
      <%= isViewMode ? "View complaint details" : "Please fill all required fields" %>
    </p>
  </div>

  <% Complaint complaint = (Complaint) request.getAttribute("complaint"); %>

  <form id="complaintForm" action="complaint" method="post">
    <c:if test="${not empty sessionScope.message}">
      <div class="alert alert-${sessionScope.messageType == 'error' ? 'danger' : 'success'} alert-dismissible fade show" role="alert">
          ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>

      <c:remove var="message" scope="session"/>
      <c:remove var="messageType" scope="session"/>
    </c:if>
    <input type="hidden" name="id" value="${complaint.complaintId}" />
    <input type="hidden" name="mode" value="<%= mode %>" />

    <div class="row mb-3">
      <div class="row mb-3">
        <div class="col-md-6 mb-3">
          <label for="date" class="form-label required-field">Date</label>

          <%
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
            String formattedDate = (complaint != null && complaint.getSubmittedAt() != null)
                    ? complaint.getSubmittedAt().toLocalDate().format(formatter)
                    : LocalDate.now().format(formatter);
          %>

          <input
                  type="text"
                  class="form-control-plaintext"
                  id="date"
                  name="date"
                  value="<%= formattedDate %>"
                  readonly
          />
        </div>

        <div class="col-md-6 mb-3">
          <label for="subject" class="form-label">Subject</label>
          <input
                  type="text"
                  class="form-control <%= isViewMode || isAdmin ? "form-control-plaintext" : "" %>"
                  id="subject"
                  name="subject"
                  value="${complaint.subject}"
                  <%= isViewMode || isAdmin? "readonly" : "required" %>
          />
        </div>
      </div>

      <div class="col-md-6 mb-3">
        <label for="priority" class="form-label required-field">Priority</label>
        <% if (isViewMode) { %>
        <input type="text" class="form-control-plaintext" value="${complaint.priority}" readonly />
        <% } else { %>
        <select class="form-select" id="priority" name="priority" required>
          <option value="">Select priority</option>
          <option value="low" ${complaint.priority == PriorityType.LOW ? 'selected' : ''}>Low</option>
          <option value="medium" ${complaint.priority == PriorityType.MEDIUM ? 'selected' : ''}>Medium</option>
          <option value="high" ${complaint.priority == PriorityType.HIGH ? 'selected' : ''}>High</option>
        </select>
        <% } %>
      </div>
    </div>

    <div class="mb-3">
      <label for="description" class="form-label required-field">Description</label>
      <% if (isViewMode || isAdmin) { %>
      <div class="form-control-plaintext">${complaint.description}</div>
      <% } else { %>
      <textarea
              class="form-control"
              id="description"
              rows="5"
              name="description"
              placeholder="Describe the complaint in detail"
              <%= isViewMode ? "readonly" : "required" %>
      >${complaint.description}</textarea>
      <% } %>
    </div>

    <% if (!isViewMode) { %>
    <div class="mb-3">
      <label for="attachment" class="form-label">Attachment</label>
      <input type="file" class="form-control" id="attachment" name="attachment" />
      <small class="text-muted">Upload photos or documents related to the complaint (optional)</small>
    </div>
    <% } %>

    <% if (isViewMode || isEditMode) { %>
    <div class="admin-section mb-3">
      <h6>Admin Remarks</h6>
      <% if (isViewMode || !isAdmin) { %>
      <div class="form-control-plaintext">${complaint.adminRemark}</div>
      <% } else { %>
      <textarea class="form-control" name="adminRemarks" rows="3" <%= !isAdmin ? "readonly" : "required" %>>${complaint.adminRemark}</textarea>
      <% } %>

      <div class="mt-2">
        <label class="form-label">Status</label>
        <% if (isViewMode || !isAdmin) { %>
        <div class="form-control-plaintext" >${complaint.complaintStatus}</div>
        <% } else if(isAdmin){ %>
        <select class="form-select" name="status">
          <option value="pending" ${complaint.complaintStatus == ComplaintStatus.PENDING ? 'selected' : ''}>Pending</option>
          <option value="in_progress" ${complaint.complaintStatus == ComplaintStatus.IN_PROGRESS ? 'selected' : ''}>In Progress</option>
          <option value="resolved" ${complaint.complaintStatus == ComplaintStatus.RESOLVED  ? 'selected' : ''}>Resolved</option>
          <option value="closed" ${complaint.complaintStatus == ComplaintStatus.CLOSED  ? 'selected' : ''}>Closed</option>
        </select>
        <% } %>
      </div>
    </div>
    <% } %>

    <div class="d-flex justify-content-end gap-2">
      <% if (isViewMode) { %>
      <button type="button" class="btn btn-primary"
              onclick="window.location.href='complaint?action=edit&id=${complaint.complaintId}&mode=edit'">
        Edit
      </button>
      <button type="button" class="btn btn-danger" onclick="confirmDelete()">
        Delete
      </button>
      <% } else { %>
      <button type="button" class="btn btn-secondary"
              onclick="<%= mode.equals("create") ? "window.parent.$('#complaintModal').modal('hide')" : "window.history.back()" %>">
        Cancel
      </button>
      <% if (isEditMode) { %>
      <button type="submit" class="btn btn-primary btn-submit" name="action" value="update">
        Update
      </button>
      <button type="button" class="btn btn-danger" onclick="confirmDelete()">
        Delete
      </button>
      <% } else { %>
      <button type="submit" class="btn btn-primary btn-submit" name="action" value="create">
        Submit Complaint
      </button>
      <% } %>
      <% } %>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
  function confirmDelete() {
    if (confirm('Are you sure you want to delete this complaint?')) {
      const form = document.createElement('form');
      form.method = 'post';
      form.action = 'complaint';

      const inputId = document.createElement('input');
      inputId.type = 'hidden';
      inputId.name = 'id';
      inputId.value = '${complaint.complaintId}';

      const inputAction = document.createElement('input');
      inputAction.type = 'hidden';
      inputAction.name = 'action';
      inputAction.value = 'delete';

      form.appendChild(inputId);
      form.appendChild(inputAction);
      document.body.appendChild(form);
      form.submit();

      if (window.parent !== window) {
        window.parent.$('#complaintModal').modal('hide');

        window.parent.$('#complaintModal').on('hidden.bs.modal', function() {
          window.parent.location.reload();
        });

        form.submit();
      } else {
        form.submit();
      }
    }
  }
</script>
</body>
</html>