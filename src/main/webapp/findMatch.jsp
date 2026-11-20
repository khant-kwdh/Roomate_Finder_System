<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) { response.sendRedirect("login.jsp"); return; }

    String url = "jdbc:mysql://127.0.0.1:3308/RoommateFinder";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    String searchAge = request.getParameter("age");
    String searchGender = request.getParameter("gender");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        String sql = "SELECT * FROM users WHERE role='user'";
        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        if(searchAge != null && !searchAge.trim().isEmpty()) {
            conditions.add("age=?");
            params.add(Integer.parseInt(searchAge));
        }
        if(searchGender != null && !searchGender.trim().isEmpty()) {
            conditions.add("gender=?");
            params.add(searchGender);
        }
        if(!conditions.isEmpty()) {
            sql += " AND " + String.join(" AND ", conditions);
        }

        pst = conn.prepareStatement(sql);
        for(int i=0; i<params.size(); i++) {
            pst.setObject(i+1, params.get(i));
        }
        rs = pst.executeQuery();

        List<Map<String,String>> users = new ArrayList<>();
        while(rs.next()) {
            Map<String,String> user = new HashMap<>();
            ResultSetMetaData md = rs.getMetaData();
            for(int i=1; i<=md.getColumnCount(); i++) {
                user.put(md.getColumnName(i), rs.getString(i));
            }
            users.add(user);
        }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Find Roommate Matches</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root { --primary:#1a73e8; --secondary:#6c757d; --light:#f8f9fa; --dark:#343a40; --gold:#ffc107; }
* { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; }
body { background:#f9fafb; color:#333; min-height:100vh; display:flex; flex-direction:column; }

/* Header */
header { background:white; box-shadow:0 2px 10px rgba(0,0,0,0.1); position:sticky; top:0; z-index:100; }
.header-content { display:flex; justify-content:space-between; align-items:center; padding:15px 20px; flex-wrap:wrap; }
.logo { display:flex; align-items:center; font-size:24px; font-weight:700; color:var(--primary); }
.logo span { color:var(--gold); }
.logo i { margin-right:10px; font-size:28px; }
nav ul { display:flex; list-style:none; flex-wrap:wrap; }
nav ul li { margin-left:20px; }
nav ul li a { font-weight:500; color:var(--dark); text-decoration:none; transition:color 0.3s; }
nav ul li a:hover, nav ul li a.active { color:var(--primary); }
.nav-buttons { display:flex; gap:10px; }
.nav-buttons .avatar { width:36px; height:36px; border-radius:50%; background:var(--gold); display:flex; align-items:center; justify-content:center; color:white; font-weight:bold; }
.nav-buttons span { font-weight:500; color:var(--dark); }

/* Search Bar */
.container { width:90%; max-width:1200px; margin:20px auto; }
.search-bar { margin-bottom:20px; text-align:center; }
.search-bar input, .search-bar select { padding:8px 12px; margin-right:10px; border-radius:6px; border:1px solid #ccc; }
.search-bar button { padding:8px 15px; border:none; border-radius:6px; background:var(--primary); color:white; cursor:pointer; }
.search-bar button:hover { background:#1557b7; }

/* Match cards */
.match-cards { display:grid; grid-template-columns:repeat(auto-fill,minmax(280px,1fr)); gap:20px; }
.match-card { background:white; border-radius:12px; padding:20px; text-align:center; box-shadow:0 5px 15px rgba(0,0,0,0.05); transition: transform 0.3s; color:#333; border-top:5px solid var(--primary); }
.match-card:hover { transform:translateY(-5px); }
.match-circle { width:80px; height:80px; background:var(--primary); color:white; font-size:2rem; font-weight:bold; display:flex; align-items:center; justify-content:center; border-radius:50%; margin:0 auto 10px auto; }
.match-name { font-size:1.2rem; color:var(--primary); margin-bottom:5px; }
.match-major { color:var(--gold); font-weight:600; margin-bottom:5px; }
.match-details p { font-size:0.95rem; color:#555; margin-bottom:5px; }
.btn-chat, .btn-connect { display:inline-block; margin:5px 5px 0 5px; padding:8px 15px; background:var(--primary); color:white; border-radius:6px; text-decoration:none; transition:0.2s; }
.btn-chat:hover, .btn-connect:hover { background:#1557b7; }

/* Footer */
footer { background:var(--dark); color:white; padding:60px 20px 30px; margin-top:auto; }
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
@media(max-width:768px){ .match-cards { grid-template-columns:1fr; } nav ul { justify-content:center; margin:15px 0; flex-wrap:wrap; } nav ul li { margin:5px 10px; } }
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
                <li><a href="findMatch.jsp" class="nav-link active">FindMatch</a></li>
                <li><a href="connections.jsp" class="nav-link">Request</a></li>
                <li><a href="chat.jsp" class="nav-link">Message</a></li>
                <li><a href="profile.jsp" class="nav-link">Profile</a></li>
                <li><a href="complain.jsp" class="nav-link">Complaint</a></li>
                <li><a href="logout.jsp" class="nav-link">Logout</a></li>
            </ul>
        </nav>
        <div class="nav-buttons">
            <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
            <span><%= username %></span>
        </div>
    </div>
</header>

<!-- Search Bar -->
<div class="container search-bar">
    <form method="get" action="findMatch.jsp">
        <input type="number" name="age" placeholder="Search by Age" value="<%= (searchAge != null) ? searchAge : "" %>">
        <select name="gender">
            <option value="">Any Gender</option>
            <option value="male" <%= "male".equals(searchGender) ? "selected" : "" %>>Male</option>
            <option value="female" <%= "female".equals(searchGender) ? "selected" : "" %>>Female</option>
            <option value="non-binary" <%= "non-binary".equals(searchGender) ? "selected" : "" %>>Non-binary</option>
            <option value="other" <%= "other".equals(searchGender) ? "selected" : "" %>>Other</option>
            <option value="prefer-not-to-say" <%= "prefer-not-to-say".equals(searchGender) ? "selected" : "" %>>Prefer not to say</option>
        </select>
        <button type="submit"><i class="fas fa-search"></i> Search</button>
    </form>
</div>

<!-- Match Cards -->
<div class="container match-cards">
<%
    if(users.isEmpty()) {
%>
    <p style="grid-column:1/-1; text-align:center; color:var(--primary);">No users found matching your search.</p>
<%
    } else {
        for(Map<String,String> user : users) {
            String firstName = user.get("first_name") != null ? user.get("first_name") : "?";
            String lastName = user.get("last_name") != null ? user.get("last_name") : "";
            String circleLetter = firstName.substring(0,1).toUpperCase();
%>
    <div class="match-card">
        <div class="match-circle"><%= circleLetter %></div>
        <h3 class="match-name"><%= firstName %> <%= lastName %></h3>
        <p class="match-major"><%= (user.get("major") != null) ? user.get("major") : "N/A" %></p>
        <div class="match-details">
            <p><i class="fas fa-user"></i> Gender: <%= user.get("gender") %></p>
            <p><i class="fas fa-birthday-cake"></i> Age: <%= user.get("age") %></p>
            <p><i class="fas fa-info-circle"></i> Bio: <%= (user.get("bio") != null) ? user.get("bio") : "N/A" %></p>
            <p><i class="fas fa-home"></i> Cleanliness: <%= user.get("cleanliness") %></p>
            <p><i class="fas fa-bed"></i> Sleep Schedule: <%= user.get("sleep_schedule") %></p>
        </div>
        <a href="chat.jsp?userId=<%= user.get("id") %>" class="btn-chat"><i class="fas fa-comment"></i> Chat</a>
        <a href="connect.jsp?userId=<%= user.get("id") %>" class="btn-connect"><i class="fas fa-user-plus"></i> Connect</a>
    </div>
<%
        }
    }
%>
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
<li><a href="userHome.jsp">Home</a></li>
<li><a href="userAboutUs.jsp">About Us</a></li>
<li><a href="userContact.jsp">Contact</a></li>
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

<%
    } catch(Exception e) { out.println("<pre>"+e+"</pre>"); }
    finally { try { if(rs!=null) rs.close(); if(pst!=null) pst.close(); if(conn!=null) conn.close(); } catch(Exception e) {} }
%>
</body>
</html>
