<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.util.*, com.roommatefinder.dao.UserDAO, com.roommatefinder.model.User" %>
<%
    // Ensure only admin can access
    String role = (String) session.getAttribute("role");
    if(role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO dao = new UserDAO();
    List<User> allUsers = dao.getAllUsers();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users - RoommateFinder</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background:#f5f7f9; margin:0; }
        header { background:#3498db; color:white; padding:15px; }
        .container { width:95%; max-width:1200px; margin:20px auto; }
        table { width:100%; border-collapse:collapse; background:white; border-radius:8px; overflow:hidden; }
        th,td { padding:12px; border-bottom:1px solid #eee; text-align:left; }
        th { background:#3498db; color:white; }
        tr:hover { background:#f9f9f9; }
        .btn { padding:5px 12px; border-radius:5px; text-decoration:none; color:white; font-size:14px; }
        .btn-edit { background:#17a2b8; }
        .btn-edit:hover { background:#138496; }
        .status-badge { padding:5px 10px; border-radius:50px; font-size:12px; font-weight:600; }
        .status-pending { background:#ffc107; color:#333; }
        .status-approved { background:#28a745; color:white; }
        .status-rejected { background:#dc3545; color:white; }
    </style>
</head>
<body>

<header>
    <div class="container">
        <h1><i class="fas fa-users"></i> Manage Users</h1>
        <p>
            Welcome, <%= session.getAttribute("username") %> |
            <a href="adminDashboard.jsp" style="color:white;">Dashboard</a> |
            <a href="logout" style="color:white;">Logout</a>
        </p>
    </div>
</header>

<div class="container">
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                for(User u : allUsers) {
                    String status = u.getStatus();
                    if(status == null || status.isEmpty()) status = "pending"; // default value

                    String badgeClass = "status-pending";
                    if("approved".equalsIgnoreCase(status)) badgeClass = "status-approved";
                    else if("rejected".equalsIgnoreCase(status)) badgeClass = "status-rejected";

                    String displayStatus = status.substring(0,1).toUpperCase() + status.substring(1).toLowerCase();
            %>
            <tr>
                <td>RF<%= u.getId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getRole() %></td>
                <td><span class="status-badge <%= badgeClass %>"><%= displayStatus %></span></td>
                <td>
                    <a href="editUser.jsp?id=<%= u.getId() %>" class="btn btn-edit">Edit</a>
                </td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>

</body>
</html>
