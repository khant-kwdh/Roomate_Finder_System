<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) { response.sendRedirect("login.jsp"); return; }

    String message = "";

    // Database setup
    String url = "jdbc:mysql://127.0.0.1:3308/RoommateFinder";
    String dbUser = "root";
    String dbPass = "";
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    List<Map<String,String>> pendingRequests = new ArrayList<>();
    List<Map<String,String>> acceptedConnections = new ArrayList<>();
    int currentUserId = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get current user's ID
        pst = conn.prepareStatement("SELECT id FROM users WHERE username=?");
        pst.setString(1, username);
        rs = pst.executeQuery();
        if(rs.next()) currentUserId = rs.getInt("id");
        rs.close(); pst.close();

        // Handle accept/reject actions
        String action = request.getParameter("action");
        String requestId = request.getParameter("id");
        if(action != null && requestId != null){
            pst = conn.prepareStatement("UPDATE connections SET status=? WHERE id=? AND receiver_id=?");
            pst.setString(1, action);
            pst.setInt(2, Integer.parseInt(requestId));
            pst.setInt(3, currentUserId);
            int updated = pst.executeUpdate();
            if(updated > 0){
                message = "Request " + action + " successfully!";
            }
            pst.close();
        }

        // Fetch pending requests
        pst = conn.prepareStatement(
            "SELECT c.id AS connection_id, u.username, u.email " +
            "FROM connections c JOIN users u ON c.requester_id = u.id " +
            "WHERE c.receiver_id = ? AND c.status = 'pending' " +
            "ORDER BY c.created_at DESC"
        );
        pst.setInt(1, currentUserId);
        rs = pst.executeQuery();
        while(rs.next()){
            Map<String,String> map = new HashMap<>();
            map.put("id", String.valueOf(rs.getInt("connection_id")));
            map.put("username", rs.getString("username"));
            map.put("email", rs.getString("email"));
            pendingRequests.add(map);
        }
        rs.close(); pst.close();

        // Fetch accepted connections
        pst = conn.prepareStatement(
            "SELECT u.username, u.email " +
            "FROM connections c JOIN users u ON (u.id = c.requester_id OR u.id = c.receiver_id) " +
            "WHERE (c.requester_id = ? OR c.receiver_id = ?) AND c.status = 'accepted' AND u.id != ?"
        );
        pst.setInt(1, currentUserId);
        pst.setInt(2, currentUserId);
        pst.setInt(3, currentUserId);
        rs = pst.executeQuery();
        while(rs.next()){
            Map<String,String> map = new HashMap<>();
            map.put("username", rs.getString("username"));
            map.put("email", rs.getString("email"));
            acceptedConnections.add(map);
        }
        rs.close(); pst.close();

    } catch(Exception e){ message = "Error: " + e.getMessage(); }
    finally { try{ if(rs!=null) rs.close(); if(pst!=null) pst.close(); if(conn!=null) conn.close(); } catch(Exception e){} }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>RoommateFinder - Connections</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root { --primary:#1a73e8; --secondary:#6c757d; --light:#f8f9fa; --dark:#343a40; --gold:#ffc107; }
* { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; }
body { background:#f9fafb; color:#333; min-height:100vh; display:flex; flex-direction:column; }

/* Header */
header { background:white; box-shadow:0 2px 10px rgba(0,0,0,0.1); position:sticky; top:0; z-index:100; }
.header-content { display:flex; justify-content:space-between; align-items:center; padding:15px 0; flex-wrap:wrap; }
.logo { display:flex; align-items:center; font-size:24px; font-weight:700; color:var(--primary); }
.logo span { color:var(--gold); }
.logo i { margin-right:10px; font-size:28px; }
nav ul { display:flex; list-style:none; flex-wrap:wrap; }
nav ul li { margin-left:20px; }
nav ul li a { font-weight:500; color:var(--dark); text-decoration:none; transition:color 0.3s; }
nav ul li a:hover, nav ul li a.active { color:var(--primary); }
.nav-buttons { display:flex; gap:10px; }
.btn { display:inline-block; padding:10px 20px; background:var(--primary); color:white; border-radius:4px; font-weight:600; border:none; cursor:pointer; transition:all 0.3s ease; text-decoration:none; text-align:center; }
.btn:hover { background:#1557b7; transform:translateY(-2px); }
.btn-outline { background:transparent; border:2px solid var(--primary); color:var(--primary); }
.btn-outline:hover { background:var(--primary); color:white; }

/* Connections container */
.container { width:90%; max-width:1000px; margin:40px auto; padding:20px; }
h2 { color:var(--primary); margin-bottom:20px; text-align:center; }
.message { text-align:center; color:green; margin-bottom:20px; font-weight:bold; }

/* Lists */
.list-group { list-style:none; padding:0; }
.list-group-item { background:white; padding:15px 20px; margin-bottom:10px; border-radius:6px; display:flex; justify-content:space-between; align-items:center; box-shadow:0 5px 15px rgba(0,0,0,0.05); }
.list-group-item button { margin-left:10px; padding:5px 12px; border:none; border-radius:4px; cursor:pointer; font-weight:500; transition:0.3s; }
.btn-accept { background:#1a73e8; color:white; }
.btn-accept:hover { background:#1557b7; }
.btn-reject { background:#dc3545; color:white; }
.btn-reject:hover { background:#a71d2a; }

/* Footer */
footer { background:var(--dark); color:white; padding:60px 0 30px; margin-top:auto; }
.footer-content { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:40px; margin-bottom:40px; }
.footer-column h3 { margin-bottom:20px; position:relative; padding-bottom:10px; }
.footer-column h3::after { content:''; position:absolute; left:0; bottom:0; width:40px; height:2px; background:var(--primary); }
.footer-column ul { list-style:none; }
.footer-column ul li { margin-bottom:12px; }
.footer-column a { color:#e2e8f0; text-decoration:none; transition:color 0.3s; }
.footer-column a:hover { color:white; }
.footer-social { display:flex; gap:15px; margin-top:10px; }
.footer-social a { display:flex; align-items:center; justify-content:center; width:35px; height:35px; border-radius:50%; background:rgba(255,255,255,0.1); transition:all 0.3s; }
.footer-social a:hover { background:var(--primary); }
.footer-bottom { text-align:center; padding-top:20px; border-top:1px solid rgba(255,255,255,0.1); }

/* Responsive */
@media(max-width:768px){ nav ul { justify-content:center; margin:20px 0; flex-wrap:wrap; } nav ul li { margin:5px 10px; } }
</style>
</head>
<body>

<!-- Header -->
<header>
    <div class="container header-content">
        <div class="logo"><i class="fas fa-house-user"></i> Roommate<span>Finder</span></div>
        <nav>
            <ul>
                <li><a href="userHome.jsp" class="nav-link">Home</a></li>
                <li><a href="findMatch.jsp" class="nav-link">FindMatch</a></li>
                <li><a href="connections.jsp" class="nav-link active">Request</a></li>
                <li><a href="chat.jsp" class="nav-link">Message</a></li>
                <li><a href="profile.jsp" class="nav-link">Profile</a></li>
                <li><a href="complain.jsp" class="nav-link">Complaint</a></li>
                <li><a href="logout.jsp" class="nav-link">Logout</a></li>
            </ul>
        </nav>
        <div class="nav-buttons">
            <div class="user-info" style="display:flex; align-items:center; gap:10px;">
                <div class="avatar" style="width:36px;height:36px;border-radius:50%;background:var(--gold);display:flex;align-items:center;justify-content:center;color:white;font-weight:bold;">
                    <%= username.substring(0,1).toUpperCase() %>
                </div>
                <span style="font-weight:500; color:var(--dark);"><%= username %></span>
            </div>
        </div>
    </div>
</header>

<div class="container">
    <% if(!message.isEmpty()){ %>
        <div class="message"><%= message %></div>
    <% } %>

    <h2>Pending Connection Requests</h2>
    <% if(pendingRequests.isEmpty()){ %>
        <p style="text-align:center;">No pending requests.</p>
    <% } else { %>
        <ul class="list-group">
        <% for(Map<String,String> req : pendingRequests){ %>
            <li class="list-group-item">
                <div>
                    <strong><%= req.get("username") %></strong> (<%= req.get("email") %>)
                </div>
                <div>
                    <form method="get" style="display:inline;">
                        <input type="hidden" name="id" value="<%= req.get("id") %>">
                        <button type="submit" name="action" value="accepted" class="btn-accept">Accept</button>
                        <button type="submit" name="action" value="rejected" class="btn-reject">Reject</button>
                    </form>
                </div>
            </li>
        <% } %>
        </ul>
    <% } %>

    <h2 style="margin-top:40px;">Accepted Connections</h2>
    <% if(acceptedConnections.isEmpty()){ %>
        <p style="text-align:center;">No accepted connections yet.</p>
    <% } else { %>
        <ul class="list-group">
        <% for(Map<String,String> connUser : acceptedConnections){ %>
            <li class="list-group-item">
                <strong><%= connUser.get("username") %></strong> (<%= connUser.get("email") %>)
            </li>
        <% } %>
        </ul>
    <% } %>
</div>

<!-- Footer -->
<footer>
<div class="container">
<div class="footer-content">
<div class="footer-column">
<h3>RoommateFinder</h3>
<p>Helping university students find compatible roommates since 2023.</p>
<div class="footer-social">
<a href="#"><i class="fab fa-facebook-f"></i></a>
<a href="#"><i class="fab fa-twitter"></i></a>
<a href="#"><i class="fab fa-instagram"></i></a>
<a href="#"><i class="fab fa-linkedin-in"></i></a>
</div>
</div>
<div class="footer-column">
<h3>Quick Links</h3>
<ul>
<li><a href="index.jsp">Home</a></li>
<li><a href="userAboutUs.jsp">About Us</a></li>
<li><a href="usserContact.jsp">Contact</a></li>
</ul>
</div>
<div class="footer-column">
<h3>Resources</h3>
<ul>
<li><a href="#">Roommate Tips</a></li>
<li><a href="#">University Housing</a></li>
<li><a href="#">FAQ</a></li>
</ul>
</div>
<div class="footer-column">
<h3>Legal</h3>
<ul>
<li><a href="#">Terms of Service</a></li>
<li><a href="#">Privacy Policy</a></li>
<li><a href="#">Cookie Policy</a></li>
</ul>
</div>
</div>
<div class="footer-bottom">© <%= java.time.Year.now() %> RoommateFinder. All rights reserved.</div>
</div>
</footer>
</body>
</html>
