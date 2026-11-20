<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.util.*,com.roommatefinder.dao.UserDAO,com.roommatefinder.model.User" %>
<%
    String role = (String)session.getAttribute("role");
    if(role==null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO dao = new UserDAO();
    List<User> pendingUsers = dao.getPendingUsers();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Verify Users</title>
    <style>
        body{font-family:Arial;background:#f7f7f7;}
        table{width:100%;border-collapse:collapse;background:white;margin:20px auto;}
        th,td{padding:10px;border:1px solid #ddd;}
        th{background:#3498db;color:white;}
        tr:hover{background:#f1f1f1;}
        .btn{padding:5px 10px;border-radius:5px;text-decoration:none;color:white;}
        .btn-approve{background:#28a745;}
        .btn-reject{background:#dc3545;}
    </style>
</head>
<body>
    <h2 style="text-align:center">Pending User Verification</h2>
    <table>
        <tr><th>ID</th><th>Username</th><th>Email</th><th>Status</th><th>Actions</th></tr>
        <%
            for(User u : pendingUsers){
        %>
        <tr>
            <td><%=u.getId()%></td>
            <td><%=u.getUsername()%></td>
            <td><%=u.getEmail()%></td>
            <td><%=u.getStatus()%></td>
            <td>
                <a href="approveUser?id=<%=u.getId()%>" class="btn btn-approve">Approve</a>
                <a href="rejectUser?id=<%=u.getId()%>" class="btn btn-reject">Reject</a>
            </td>
        </tr>
        <% } %>
    </table>
</body>
</html>
