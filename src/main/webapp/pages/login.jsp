<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <base href="${pageContext.request.contextPath}/" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Municipal Council - Login</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      :root {
        --primary-color: #1e3c72;
        --secondary-color: #2a5298;
        --accent-color: #1a4b8c;
        --light-gray: #f8fafc;
      }

      body {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        background-color: var(--light-gray);
        font-family: "Segoe UI", system-ui, -apple-system, sans-serif;
      }

      header {
        background-color: var(--primary-color);
      }

      .navbar-brand {
        font-weight: 500;
      }

      .login-main {
        flex: 1;
        display: flex;
        align-items: center;
        padding: 2rem 0;
      }

      .login-container {
        max-width: 420px;
        width: 100%;
        padding: 2.5rem;
        background: white;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
        margin: 0 auto;
      }

      .login-logo {
        text-align: center;
        margin-bottom: 2.5rem;
      }

      .login-logo h1 {
        font-weight: 600;
        color: var(--primary-color);
        font-size: 1.8rem;
        margin-bottom: 0.5rem;
      }

      .login-logo p {
        color: #64748b;
        font-size: 0.95rem;
      }

      .form-group {
        margin-bottom: 1.5rem;
      }

      .form-control {
        padding: 0.75rem 1rem;
        border-radius: 8px;
        border: 1px solid #e2e8f0;
        transition: all 0.3s;
        height: 48px;
      }

      .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
      }

      .password-wrapper {
        position: relative;
      }

      .password-toggle {
        position: absolute;
        right: 12px;
        top: 50%;
        transform: translateY(-50%);
        cursor: pointer;
        color: var(--secondary-color);
        z-index: 5;
        background: none;
        border: none;
        padding: 0.5rem;
      }

      .btn-login {
        width: 100%;
        padding: 0.75rem;
        border-radius: 8px;
        background-color: var(--primary-color);
        border: none;
        font-weight: 500;
        transition: all 0.3s;
        height: 48px;
      }

      .btn-login:hover {
        background-color: var(--accent-color);
      }

      .forgot-password {
        text-align: right;
        margin: 1rem 0 1.5rem;
      }

      .forgot-password a {
        color: var(--secondary-color);
        text-decoration: none;
        font-size: 0.9rem;
        transition: color 0.2s;
      }

      .forgot-password a:hover {
        color: var(--primary-color);
        text-decoration: underline;
      }

      .form-label {
        margin-bottom: 0.5rem;
        font-weight: 500;
        color: var(--secondary-color);
      }
    </style>
  </head>
  <body>
    <header>
      <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
          <a class="navbar-brand" href="../index.jsp">
            <i class="fas fa-city me-2"></i>Municipal CMS
          </a>
        </div>
      </nav>
    </header>

    <main class="login-main">
      <div class="container">
        <div class="login-container">
          <div class="login-logo">
            <h1>Municipal Complaint System</h1>
            <p>Staff login portal</p>
          </div>

          <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="form-group">
              <label for="usernameOrEmail" class="form-label"
                >Username or Email</label
              >
              <input
                type="text"
                class="form-control"
                id="usernameOrEmail"
                name="usernameOrEmail"
                placeholder="Enter your username or email"
                required
              />
            </div>

            <div class="form-group">
              <label for="password" class="form-label">Password</label>
              <div class="password-wrapper">
                <input
                  type="password"
                  class="form-control"
                  id="password"
                  name="password"
                  placeholder="Enter your password"
                  required
                />
                <button
                  type="button"
                  class="password-toggle"
                  id="togglePassword"
                >
                  <i class="fas fa-eye"></i>
                </button>
              </div>
            </div>

            <div class="forgot-password">
              <a href="forgot-password.jsp">Forgot password?</a>
            </div>

            <% String loginError = (String) request.getAttribute("loginError");
            %> <% if (loginError != null) { %>
            <div class="alert alert-danger mb-3">
              <strong>Error: </strong><%= loginError %>
            </div>
            <% } %>

            <button type="submit" class="btn btn-primary btn-login">
              Sign In
            </button>
          </form>
        </div>
      </div>
    </main>

    <footer class="py-3 bg-dark">
      <div class="container text-center">
        <p class="mb-0 small text-info">
          &copy; 2025 Municipal Council IT Department
        </p>
      </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="js/login.js"></script>
  </body>
</html>
