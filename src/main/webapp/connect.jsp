<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if(username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userIdToConnect = request.getParameter("userId");
    String message = "";

    if(userIdToConnect == null || userIdToConnect.trim().isEmpty()) {
        message = "Invalid user ID.";
    } else {
        String url = "jdbc:mysql://127.0.0.1:3308/RoommateFinder";
        String dbUser = "root";
        String dbPass = "";

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, dbUser, dbPass);

            // Get current user's ID
            String getUserIdSQL = "SELECT id FROM users WHERE username=?";
            pst = conn.prepareStatement(getUserIdSQL);
            pst.setString(1, username);
            rs = pst.executeQuery();

            int currentUserId = 0;
            if(rs.next()) {
                currentUserId = rs.getInt("id");
            }
            rs.close();
            pst.close();

            if(currentUserId == Integer.parseInt(userIdToConnect)) {
                message = "You cannot connect with yourself!";
            } else {
                // Check if connection request already exists
                String checkSQL = "SELECT * FROM connections WHERE requester_id=? AND receiver_id=?";
                pst = conn.prepareStatement(checkSQL);
                pst.setInt(1, currentUserId);
                pst.setInt(2, Integer.parseInt(userIdToConnect));
                rs = pst.executeQuery();

                if(rs.next()) {
                    message = "You have already sent a connection request to this user.";
                } else {
                    rs.close();
                    pst.close();

                    // Insert connection request
                    String insertSQL = "INSERT INTO connections(requester_id, receiver_id, status, created_at) VALUES(?,?,?,NOW())";
                    pst = conn.prepareStatement(insertSQL);
                    pst.setInt(1, currentUserId);
                    pst.setInt(2, Integer.parseInt(userIdToConnect));
                    pst.setString(3, "pending");
                    int inserted = pst.executeUpdate();

                    if(inserted > 0) {
                        message = "Connection request sent successfully!";
                    } else {
                        message = "Failed to send connection request. Try again.";
                    }
                }
            }
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            try { if(rs != null) rs.close(); if(pst != null) pst.close(); if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Connect</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body { font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; background:#f9fafb; color:#333; display:flex; justify-content:center; align-items:center; height:100vh; }
.message-box { background:white; padding:30px; border-radius:12px; box-shadow:0 5px 20px rgba(0,0,0,0.1); text-align:center; max-width:400px; }
.message-box h2 { margin-bottom:20px; color:#1a73e8; }
.message-box a { display:inline-block; margin-top:15px; padding:10px 20px; background:#1a73e8; color:white; border-radius:6px; text-decoration:none; transition:0.3s; }
.message-box a:hover { background:#1557b7; }
</style>
</head>
<body>
<div class="message-box">
    <h2><i class="fas fa-user-plus"></i> Connect</h2>
    <p><%= message %></p>
    <a href="findMatch.jsp"><i class="fas fa-arrow-left"></i> Back to Matches</a>
</div>
</body>
</html>
