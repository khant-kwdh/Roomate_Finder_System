<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.sql.*,com.roommatefinder.DBConnection" %>

<%
    // Check admin role
    String role = (String)session.getAttribute("role");
    if(role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Show message after resolving complaints
    String resolveMessage = (String)session.getAttribute("resolveMessage");
    if(resolveMessage != null){
        session.removeAttribute("resolveMessage");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Complaints</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        header {
            background: #3498db;
            color: white;
            padding: 15px;
            text-align: center;
        }
        table {
            width: 90%;
            border-collapse: collapse;
            background: white;
            margin: 20px auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #3498db;
            color: white;
        }
        tr:hover {
            background: #f1f1f1;
        }
        .btn {
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            font-size: 14px;
        }
        .btn-resolve { background: #28a745; }
        .btn-resolve:hover { background: #218838; }
        .status-open { color: red; font-weight: bold; }
        .status-resolved { color: green; font-weight: bold; }
        .alert {
            width: 90%;
            margin: 15px auto;
            padding: 12px;
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            border-radius: 4px;
            text-align: center;
        }
    </style>
</head>
<body>
    <header>
        <h2>Manage Complaints</h2>
    </header>

    <% if(resolveMessage != null){ %>
        <div class="alert"><%= resolveMessage %></div>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>User</th>
            <th>Description</th>
            <th>Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            try(Connection conn = DBConnection.getConnection();
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(
                    "SELECT c.id, u.username, c.details, c.created_at, c.status " +
                    "FROM complaints c JOIN users u ON c.user_id = u.id " +
                    "ORDER BY c.created_at DESC")) {

                while(rs.next()){
        %>
        <tr>
            <td>CMP<%= rs.getInt("id") %></td>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getString("details") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
            <td>
                <% if("open".equalsIgnoreCase(rs.getString("status"))){ %>
                    <span class="status-open">Open</span>
                <% } else { %>
                    <span class="status-resolved">Resolved</span>
                <% } %>
            </td>
            <td>
                <% if("open".equalsIgnoreCase(rs.getString("status"))){ %>
                    <a href="resolveComplaint.jsp?id=<%= rs.getInt("id") %>" class="btn btn-resolve">Resolve</a>
                <% } else { %>
                    ✔
                <% } %>
            </td>
        </tr>
        <%  }
            } catch(Exception e){
                out.print("<tr><td colspan=6>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>
