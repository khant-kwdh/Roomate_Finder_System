<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<%@ page import="com.roommatefinder.dao.UserDAO, com.roommatefinder.model.User" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    if(idParam == null) {
        response.sendRedirect("manageUsers.jsp");
        return;
    }

    int userId = Integer.parseInt(idParam);
    UserDAO dao = new UserDAO();
    User user = dao.getUserById(userId);

    if(user == null) {
        response.sendRedirect("manageUsers.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit User - RoommateFinder</title>
    <style>
        body { font-family: Arial; background:#f4f6f9; display:flex; justify-content:center; align-items:center; min-height:100vh; margin:0; }
        .form-container { background:#fff; padding:30px 40px; border-radius:10px; box-shadow:0 4px 12px rgba(0,0,0,0.15); width:100%; max-width:400px; }
        label { display:block; margin-top:10px; font-weight:bold; }
        input, select { width:100%; padding:10px; margin-top:5px; border-radius:5px; border:1px solid #ccc; box-sizing:border-box; }
        button { margin-top:20px; width:100%; padding:10px; background:#0275d8; border:none; color:white; border-radius:5px; cursor:pointer; }
        button:hover { background:#025aa5; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Edit User</h2>
    <form action="updateUser" method="post">
        <input type="hidden" name="id" value="<%= user.getId() %>">

        <label>Username</label>
        <input type="text" name="username" value="<%= user.getUsername() %>" required>

        <label>Email</label>
        <input type="email" name="email" value="<%= user.getEmail() %>" required>

        <label>Role</label>
        <select name="role" required>
            <option value="user" <%= "user".equals(user.getRole()) ? "selected" : "" %>>User</option>
            <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
        </select>

        <label>Status</label>
        <select name="status" required>
            <option value="pending" <%= "pending".equals(user.getStatus()) ? "selected" : "" %>>Pending</option>
            <option value="approved" <%= "approved".equals(user.getStatus()) ? "selected" : "" %>>Approved</option>
            <option value="rejected" <%= "rejected".equals(user.getStatus()) ? "selected" : "" %>>Rejected</option>
        </select>

        <button type="submit">Update User</button>
    </form>
</div>
</body>
</html>
