
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    if(session.getAttribute("currentUser") == null){
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    }
%>

Welcome ${currentUser.getName()}
</body>
</html>
