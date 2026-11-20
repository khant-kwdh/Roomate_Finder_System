<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.roommatefinder.DBConnection" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String,String>> connectionsList = new ArrayList<>();
    try(Connection conn = DBConnection.getConnection();
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(
            "SELECT u1.username AS user1, u2.username AS user2, c.created_at " +
            "FROM connections c " +
            "JOIN users u1 ON c.requester_id = u1.id " +
            "JOIN users u2 ON c.receiver_id = u2.id " +
            "WHERE c.status='accepted' ORDER BY c.created_at DESC"
        )) {
        while(rs.next()){
            Map<String,String> map = new HashMap<>();
            map.put("user1", rs.getString("user1"));
            map.put("user2", rs.getString("user2"));
            map.put("date", rs.getTimestamp("created_at").toString());
            connectionsList.add(map);
        }
    } catch(Exception e){ out.println("Error: "+e.getMessage()); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Accepted Connections</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body { font-family:'Segoe UI',Tahoma,sans-serif; background:#f9fafb; color:#333; }
.container { width:90%; max-width:1000px; margin:40px auto; }
h2 { color:#1a73e8; text-align:center; margin-bottom:20px; }
table { width:100%; border-collapse:collapse; background:white; border-radius:8px; overflow:hidden; }
th, td { padding:12px; border-bottom:1px solid #eee; text-align:left; }
th { background:#1a73e8; color:white; }
tr:hover { background:#f1f1f1; }
</style>
</head>
<body>
<div class="container">
    <h2>Accepted User Connections</h2>
    <table>
        <thead>
            <tr>
                <th>User 1</th>
                <th>User 2</th>
                <th>Connected At</th>
            </tr>
        </thead>
        <tbody>
        <% for(Map<String,String> conn : connectionsList){ %>
            <tr>
                <td><%= conn.get("user1") %></td>
                <td><%= conn.get("user2") %></td>
                <td><%= conn.get("date") %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
