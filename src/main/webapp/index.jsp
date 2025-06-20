<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Municipal Council - Complaint System</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      html,
      body {
        height: 100%;
        margin: 0;
      }

      body {
        display: flex;
        flex-direction: column;
      }

      .hero-section {
        background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
        color: white;
        padding: 4rem 0;
        flex: 1;
      }

      .navbar {
        background-color: #1e3c72 !important;
      }

      .btn-primary {
        background-color: #2a5298;
        border-color: #2a5298;
      }

      footer {
        flex-shrink: 0;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark">
      <div class="container">
        <a class="navbar-brand" href="#">
          <i class="fas fa-city me-1"></i>Municipal CMS
        </a>
      </div>
    </nav>

    <section class="hero-section text-center">
      <div class="container h-100 d-flex flex-column justify-content-center">
        <div>
          <h1 class="display-5 fw-bold mb-3">Municipal Complaint System</h1>
          <p class="lead mb-4">
            Submit and track complaints with the local council
          </p>
          <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
            <a href="pages/login.jsp" class="btn btn-primary btn-lg px-4">
              <i class="fas fa-sign-in-alt me-1"></i> Login
            </a>
          </div>
        </div>
      </div>
    </section>

    <footer class="py-3 bg-dark">
      <div class="container text-center">
        <p class="mb-0 small text-info">
          &copy; 2025 Municipal Council IT Department
        </p>
      </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
