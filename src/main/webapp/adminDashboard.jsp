<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.roommatefinder.DBConnection" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");

    // Accepted connections list
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
<title>RoommateFinder - Admin Dashboard</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root { 
    --primary:#1a73e8; 
    --secondary:#6c757d; 
    --light:#f8f9fa; 
    --dark:#343a40; 
    --gold:#ffc107; 
}

* { 
    margin:0; 
    padding:0; 
    box-sizing:border-box; 
    font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; 
}

body { 
    background:#f9fafb; 
    color:#333; 
    min-height:100vh; 
    display:flex; 
    flex-direction:column; 
}

/* Header */
header { 
    background:var(--primary); 
    color:white; 
    padding:15px 0; 
    position:sticky; 
    top:0; 
    z-index:100; 
    box-shadow:0 2px 8px rgba(0,0,0,0.1);
}
header .navbar { 
    display:flex; 
    justify-content:space-between; 
    align-items:center; 
    flex-wrap:wrap; 
    width:95%; 
    max-width:1200px; 
    margin:0 auto; 
}
header .logo { 
    font-size:22px; 
    font-weight:bold; 
    color:white; 
    text-decoration:none; 
    display:flex; 
    align-items:center; 
}
header .logo i { margin-right:8px; }
header .nav-links { display:flex; list-style:none; gap:18px; }
header .nav-links a { 
    color:white; 
    text-decoration:none; 
    font-weight:500; 
    transition:0.3s;
}
header .nav-links a:hover { color:var(--gold); }
header .auth-info { font-weight:500; }

/* Dashboard Cards */
.dashboard { padding:30px 0; }
.dashboard-cards { 
    display:grid; 
    grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); 
    gap:25px; 
}
.card { 
    background:white; 
    border-radius:14px; 
    box-shadow:0 4px 12px rgba(0,0,0,0.06); 
    overflow:hidden; 
    text-align:center; 
    transition:transform 0.2s;
}
.card:hover { transform:translateY(-4px); }
.card-header { 
    background:var(--primary); 
    color:white; 
    padding:12px; 
    font-weight:600; 
    font-size:16px; 
}
.card-body { padding:20px; }
.stat { 
    font-size:30px; 
    font-weight:bold; 
    color:var(--dark); 
    margin-bottom:8px; 
}
.stat-desc { 
    color:var(--secondary); 
    margin-bottom:15px; 
    font-size:14px;
}
.btn { 
    display:inline-block; 
    padding:8px 15px; 
    border-radius:6px; 
    text-decoration:none; 
    color:white; 
    background:var(--primary); 
    font-weight:500; 
    transition:0.3s; 
    font-size:14px;
}
.btn:hover { background:#1557b7; }
.btn-danger { background:#dc3545; }
.btn-danger:hover { background:#a71d2a; }

/* Sections & Tables */
section h2 { 
    font-size:20px; 
    margin:25px 0 12px; 
    color:var(--primary); 
    border-bottom:2px solid #eee; 
    padding-bottom:5px; 
    font-weight:600;
}
table { 
    width:100%; 
    border-collapse:collapse; 
    background:white; 
    border-radius:8px; 
    overflow:hidden; 
    margin-bottom:30px; 
    box-shadow:0 2px 6px rgba(0,0,0,0.05);
}
th,td { 
    padding:12px 14px; 
    border-bottom:1px solid #eee; 
    text-align:left; 
    font-size:14px;
}
th { 
    background:var(--primary); 
    color:white; 
    font-weight:600;
}
tr:hover td { background:#f8faff; }

/* Footer */
footer { 
    background:var(--dark); 
    color:white; 
    text-align:center; 
    padding:15px; 
    margin-top:auto; 
    font-size:14px;
}

/* Responsive */
@media(max-width:768px){
    header .navbar { flex-direction:column; gap:10px; }
    .dashboard-cards { grid-template-columns:1fr; }
    th,td { font-size:13px; }
}
</style>
<script>
function confirmResolve(id) {
    if(confirm("Are you sure you want to mark this complaint as resolved?")) {
        window.location.href = "resolveComplaint.jsp?id=" + id;
    }
}
</script>
</head>
<body>

<!-- Header -->
<header>
    <nav class="navbar">
        <a href="adminDashboard.jsp" class="logo"><i class="fas fa-home"></i> RoommateFinder</a>
        <ul class="nav-links">
            <li><a href="adminDashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
        <div class="auth-info">Welcome, <%= username %></div>
    </nav>
</header>

<!-- Dashboard Cards -->
<section class="dashboard">
<div class="container">
    <div class="dashboard-cards">

        <!-- Total Users -->
        <div class="card">
            <div class="card-header"><i class="fas fa-users"></i> Total Users</div>
            <div class="card-body">
                <div class="stat">
                    <%
                        try(Connection conn = DBConnection.getConnection();
                            Statement st = conn.createStatement();
                            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users")) {
                            if(rs.next()) out.print(rs.getInt(1));
                        } catch(Exception e){ out.print("0"); }
                    %>
                </div>
                <div class="stat-desc">Registered users</div>
                <a href="manageUsers.jsp" class="btn">View All</a>
            </div>
        </div>

        <!-- Active Complaints -->
        <div class="card">
            <div class="card-header"><i class="fas fa-comments"></i> Active Complaints</div>
            <div class="card-body">
                <div class="stat">
                    <%
                        try(Connection conn = DBConnection.getConnection();
                            Statement st = conn.createStatement();
                            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM complaints WHERE status='open'")) {
                            if(rs.next()) out.print(rs.getInt(1));
                        } catch(Exception e){ out.print("0"); }
                    %>
                </div>
                <div class="stat-desc">Open complaints</div>
                <a href="manageComplaints.jsp" class="btn">Resolve Issues</a>
            </div>
        </div>

        <!-- Accepted Connections -->
        <div class="card">
            <div class="card-header"><i class="fas fa-handshake"></i> Accepted Connections</div>
            <div class="card-body">
                <div class="stat">
                    <%
                        try(Connection conn = DBConnection.getConnection();
                            Statement st = conn.createStatement();
                            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM connections WHERE status='accepted'")) {
                            if(rs.next()) out.print(rs.getInt(1));
                        } catch(Exception e){ out.print("0"); }
                    %>
                </div>
                <div class="stat-desc">Accepted connections</div>
                <a href="viewConnections.jsp" class="btn">View Connections</a>
            </div>
        </div>

    </div>
</div>
</section>

<!-- Active Complaints Table -->
<section id="complaints">
<div class="container">
    <h2>Active Complaints</h2>
    <table>
        <tr><th>ID</th><th>User</th><th>Description</th><th>Date</th><th>Status</th><th>Actions</th></tr>
        <%
            try(Connection conn = DBConnection.getConnection();
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(
                    "SELECT c.id, u.username, c.details, c.created_at, c.status " +
                    "FROM complaints c JOIN users u ON c.user_id=u.id WHERE c.status='open' ORDER BY c.created_at DESC LIMIT 10")) {
                while(rs.next()){
        %>
            <tr>
                <td>CMP<%= rs.getInt("id") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("details") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getString("status") %></td>
                <td>
                    <button class="btn btn-danger" onclick="confirmResolve(<%= rs.getInt("id") %>)">
                        <i class="fas fa-check"></i> Resolve
                    </button>
                </td>
            </tr>
        <%
                }
            } catch(Exception e){ out.println("<tr><td colspan='6'>"+e.getMessage()+"</td></tr>"); }
        %>
    </table>
</div>
</section>

<!-- Accepted Connections Table -->
<section>
<div class="container">
    <h2>Accepted Connections</h2>
    <table>
        <tr><th>User 1</th><th>User 2</th><th>Connected At</th></tr>
        <%
            for(Map<String,String> conn : connectionsList){
        %>
            <tr>
                <td><%= conn.get("user1") %></td>
                <td><%= conn.get("user2") %></td>
                <td><%= conn.get("date") %></td>
            </tr>
        <%
            }
        %>
    </table>
</div>
</section>

<!-- Contact Messages Table -->
<section>
<div class="container">
    <h2>Contact Messages</h2>
    <table>
        <tr><th>ID</th><th>Name</th><th>Email</th><th>Subject</th><th>Message</th><th>Sent At</th></tr>
        <%
            int counter=1;
            try(Connection conn = DBConnection.getConnection();
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM contact_messages ORDER BY sent_at DESC LIMIT 10")) {
                while(rs.next()){
        %>
            <tr>
                <td><%= counter++ %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("subject") %></td>
                <td><%= rs.getString("message") %></td>
                <td><%= rs.getTimestamp("sent_at") %></td>
            </tr>
        <%
                }
            } catch(Exception e){ out.println("<tr><td colspan='6'>"+e.getMessage()+"</td></tr>"); }
        %>
    </table>
</div>
</section>

<footer>
    <p>&copy; 2025 RoommateFinder. All rights reserved.</p>
</footer>

</body>
</html>
