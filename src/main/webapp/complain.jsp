<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.sql.*, com.roommatefinder.DBConnection" %>
<%
    // Check if user is logged in
    String username = (String) session.getAttribute("username");
    if(username == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle form submission
    String message = "";
    if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter("complaintDetails") != null){
        String details = request.getParameter("complaintDetails").trim();
        if(!details.isEmpty()){
            try(Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO complaints(user_id, details, status, created_at) VALUES ((SELECT id FROM users WHERE username=?), ?, 'open', NOW())")) {
                pst.setString(1, username);
                pst.setString(2, details);
                int inserted = pst.executeUpdate();
                message = (inserted > 0) ? "Your complaint has been submitted." : "Failed to submit complaint. Try again.";
            } catch(Exception e){
                message = "Error: " + e.getMessage();
            }
        } else {
            message = "Please enter your complaint details.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Submit Complaint - RoommateFinder</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
:root { --primary:#1a73e8; --secondary:#6c757d; --light:#f8f9fa; --dark:#343a40; --gold:#ffc107; }
* { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; }
body { background:#f9fafb; color:#333; min-height:100vh; display:flex; flex-direction:column; }
.container { width:90%; max-width:1200px; margin:0 auto; padding:20px; }

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

/* Hero */
.hero { padding:80px 20px; background:linear-gradient(135deg, rgba(26,115,232,0.85) 0%, rgba(26,115,232,0.8) 100%), url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'); background-size:cover; background-position:center; color:white; text-align:center; border-radius:8px; margin:40px 0; }
.hero h1 { font-size:42px; margin-bottom:20px; }
.hero p { font-size:18px; max-width:600px; margin:0 auto 30px; opacity:0.9; }
.avatar { width:36px; height:36px; border-radius:50%; background:var(--gold); display:flex; align-items:center; justify-content:center; color:white; font-weight:bold; }


/* Table */
h2 { color:var(--primary); margin-bottom:20px; }
textarea { resize:none; }
.btn-primary { background:var(--primary); border:none; }
.btn-primary:hover { background:#1557b7; }
.btn-danger { background:#dc3545; border:none; color:white; padding:6px 12px; border-radius:4px; cursor:pointer; }
.btn-danger:hover { background:#b02a37; }
table { width:100%; border-collapse:collapse; margin-top:30px; }
table th, table td { padding:12px; border-bottom:1px solid #eee; text-align:left; }
table th { background:var(--primary); color:white; }
tr:hover { background:#f1f1f1; }
@media (max-width:768px){
    .header-content { flex-direction:column; text-align:center; }
    nav ul { justify-content:center; margin:20px 0; flex-wrap:wrap; }
    nav ul li { margin:5px 10px; }
    .hero h1 { font-size:32px; }
    .section-title { font-size:28px; }
</style>
</head>
<body>

<!-- Header -->
<header>
    <div class="container header-content">
        <div class="logo"><i class="fas fa-house-user"></i> Roommate<span>Finder</span></div>
        <nav>
            <ul>
                <li><a href="userHome.jsp">Home</a></li>
                <li><a href="findMatch.jsp">FindMatch</a></li>
                <li><a href="connections.jsp">Request</a></li>
                <li><a href="chat.jsp">Message</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="complain.jsp" class="active">Complain</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
        <div class="nav-buttons">
            <div class="user-info" style="display:flex; align-items:center; gap:10px;">
                <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
                <span style="font-weight:500; color:var(--dark);"><%= username %></span>
            </div>
        </div>
    </div>
</header>

<div class="container">
    <h2><i class="fas fa-exclamation-triangle"></i> Submit a Complaint</h2>
    <% if(!message.isEmpty()){ %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>
    <form method="post" action="complain.jsp">
        <div class="mb-3">
            <textarea name="complaintDetails" class="form-control" placeholder="Describe your issue..." required rows="5"></textarea>
        </div>
        <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Submit Complaint</button>
    </form>

    <!-- User's Previous Complaints -->
    <h2 class="mt-5"><i class="fas fa-list"></i> My Complaints</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Details</th>
                <th>Status</th>
                <th>Submitted At</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            try(Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(
                    "SELECT id, details, status, created_at FROM complaints WHERE user_id=(SELECT id FROM users WHERE username=?) ORDER BY created_at DESC")) {
                pst.setString(1, username);
                ResultSet rs = pst.executeQuery();
                boolean hasComplaints = false;
                while(rs.next()){
                    hasComplaints = true;
                    int cid = rs.getInt("id");
        %>
            <tr>
                <td>CMP<%= cid %></td>
                <td><%= rs.getString("details") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td>
                    <form method="post" action="deleteComplaint.jsp" onsubmit="return confirm('Are you sure you want to delete this complaint?');">
                        <input type="hidden" name="complaintId" value="<%= cid %>"/>
                        <button type="submit" class="btn btn-danger"><i class="fas fa-trash"></i> Delete</button>
                    </form>
                </td>
            </tr>
        <%
                }
                if(!hasComplaints){
        %>
            <tr><td colspan="5" class="text-center">You have not submitted any complaints yet.</td></tr>
        <%
                }
            } catch(Exception e){
        %>
            <tr><td colspan="5" class="text-danger">Error: <%= e.getMessage() %></td></tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
