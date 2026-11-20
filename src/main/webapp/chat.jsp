<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) { response.sendRedirect("login.jsp"); return; }

    String url = "jdbc:mysql://127.0.0.1:3308/roommatefinder";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    int currentUserId = -1;
    int targetUserId = -1;
    List<Map<String,Object>> chatList = new ArrayList<>();
    List<Map<String,Object>> messages = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get current user ID
        pst = conn.prepareStatement("SELECT id FROM users WHERE username=?");
        pst.setString(1, username);
        rs = pst.executeQuery();
        if(rs.next()) currentUserId = rs.getInt("id");
        rs.close(); pst.close();

        // Load chat list with last message preview
        pst = conn.prepareStatement(
            "SELECT u.id, u.username, " +
            "  (SELECT m.message FROM messages m " +
            "   WHERE (m.sender_id=u.id AND m.receiver_id=?) OR (m.sender_id=? AND m.receiver_id=u.id) " +
            "   ORDER BY m.timestamp DESC LIMIT 1) AS lastMessage " +
            "FROM users u " +
            "WHERE u.id IN (" +
            "  SELECT DISTINCT CASE WHEN sender_id=? THEN receiver_id ELSE sender_id END AS user_id " +
            "  FROM messages WHERE sender_id=? OR receiver_id=?" +
            ") " +
            "ORDER BY lastMessage DESC"
        );
        pst.setInt(1, currentUserId);
        pst.setInt(2, currentUserId);
        pst.setInt(3, currentUserId);
        pst.setInt(4, currentUserId);
        pst.setInt(5, currentUserId);
        rs = pst.executeQuery();
        while(rs.next()) {
            Map<String,Object> user = new HashMap<>();
            user.put("id", rs.getInt("id"));
            user.put("username", rs.getString("username"));
            user.put("lastMessage", rs.getString("lastMessage"));
            chatList.add(user);
        }
        rs.close(); pst.close();

        // Determine target user
        String userIdParam = request.getParameter("userId");
        if (userIdParam != null) targetUserId = Integer.parseInt(userIdParam);
        else if (!chatList.isEmpty()) targetUserId = (Integer) chatList.get(0).get("id");

        // Insert new message if provided
        String newMessage = request.getParameter("message");
        if (newMessage != null && !newMessage.trim().isEmpty() && targetUserId > 0) {
            pst = conn.prepareStatement("INSERT INTO messages(sender_id, receiver_id, message) VALUES(?,?,?)");
            pst.setInt(1, currentUserId);
            pst.setInt(2, targetUserId);
            pst.setString(3, newMessage);
            pst.executeUpdate();
            pst.close();
        }

        // Load chat history with target user
        if (targetUserId > 0) {
            pst = conn.prepareStatement(
                "SELECT m.*, u.username AS senderName FROM messages m " +
                "JOIN users u ON m.sender_id=u.id " +
                "WHERE (sender_id=? AND receiver_id=?) OR (sender_id=? AND receiver_id=?) " +
                "ORDER BY timestamp ASC"
            );
            pst.setInt(1, currentUserId);
            pst.setInt(2, targetUserId);
            pst.setInt(3, targetUserId);
            pst.setInt(4, currentUserId);
            rs = pst.executeQuery();
            while(rs.next()) {
                Map<String,Object> msg = new HashMap<>();
                msg.put("sender", rs.getString("senderName"));
                msg.put("text", rs.getString("message"));
                msg.put("time", rs.getTimestamp("timestamp"));
                messages.add(msg);
            }
            rs.close(); pst.close();
        }

    } catch(Exception e) {
        out.println("<pre>"+e+"</pre>");
    } finally {
        try { if(rs!=null) rs.close(); if(pst!=null) pst.close(); if(conn!=null) conn.close(); } catch(Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>RoommateFinder - Chat</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root { --primary:#1a73e8; --secondary:#6c757d; --gold:#ffc107; }
* { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; }
body { background:#f8f9fa; color:#333; display:flex; flex-direction:column; min-height:100vh; }
header { background:white; box-shadow:0 2px 10px rgba(0,0,0,0.1); position:sticky; top:0; z-index:100; padding:15px 20px; display:flex; justify-content:space-between; align-items:center; }
header .logo { font-size:24px; font-weight:700; color:var(--primary); } header .logo span { color:var(--gold); }
nav ul { display:flex; list-style:none; gap:20px; }
nav ul li a { text-decoration:none; color:#333; font-weight:500; } nav ul li a.active, nav ul li a:hover { color:var(--primary); }
.nav-user { display:flex; align-items:center; gap:10px; }
.nav-user .avatar { width:36px; height:36px; border-radius:50%; background:var(--gold); display:flex; justify-content:center; align-items:center; color:white; font-weight:bold; }

/* Chat Layout */
.container { display:flex; flex:1; height:calc(100vh - 70px); }
.sidebar { width:25%; background:#fff; border-right:1px solid #ddd; overflow-y:auto; }
.chat-user { display:flex; align-items:center; padding:10px 15px; cursor:pointer; border-bottom:1px solid #eee; }
.chat-user:hover { background:#f0f0f0; }
.chat-user.active { background:#e7f3ff; font-weight:bold; }
.user-circle { width:35px; height:35px; border-radius:50%; background:var(--primary); color:white; display:flex; justify-content:center; align-items:center; margin-right:10px; }
.user-name { flex:1; display:flex; flex-direction:column; }
.user-name .last-msg { font-size:12px; color:#888; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }
.chat-area { flex:1; display:flex; flex-direction:column; background:#fff; }
.chat-header { padding:15px; border-bottom:1px solid #ddd; font-weight:bold; background:#f5f5f5; }
.chat-messages { flex:1; padding:15px; overflow-y:auto; background:#fafafa; display:flex; flex-direction:column; gap:8px; }
.message { padding:10px 14px; border-radius:12px; word-wrap:break-word; max-width:70%; }
.message.you { background:var(--primary); color:white; align-self:flex-end; }
.message.not-you { background:var(--secondary); color:white; align-self:flex-start; }
.message .sender { font-weight:bold; margin-right:5px; }
.message small { display:block; font-size:10px; margin-top:2px; opacity:0.8; }
.chat-input { padding:10px; border-top:1px solid #ddd; background:#fff; }
.chat-input form { display:flex; }
.chat-input input[type=text] { flex:1; padding:10px; border:1px solid #ccc; border-radius:6px; }
.chat-input button { padding:10px 20px; margin-left:10px; background:var(--primary); color:white; border:none; border-radius:6px; cursor:pointer; }
.chat-input button:hover { background:#1557b7; }
@media(max-width:768px) { .container { flex-direction:column; } .sidebar { width:100%; border-right:none; border-bottom:1px solid #ddd; } }
</style>
</head>
<body>

<header>
    <div class="logo"><i class="fas fa-comments"></i> Roommate<span>Finder</span></div>
    <nav>
        <ul>
            <li><a href="userHome.jsp">Home</a></li>
            <li><a href="findMatch.jsp">FindMatch</a></li>
            <li><a href="connections.jsp">Request</a></li>
            <li><a href="chat.jsp" class="active">Message</a></li>
            <li><a href="profile.jsp">Profile</a></li>
            <li><a href="complain.jsp" >Complaint</a></li>
            <li><a href="logout.jsp">Logout</a></li>
        </ul>
    </nav>
    <div class="nav-user">
        <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
        <span><%= username %></span>
    </div>
</header>

<div class="container">
    <div class="sidebar">
        <h3 style="padding:10px 15px;">Chats</h3>
        <% for(Map<String,Object> u : chatList) { 
               String uname = u.get("username").toString();
               String firstInitial = uname.substring(0,1).toUpperCase();
               String lastMsg = u.get("lastMessage") != null ? u.get("lastMessage").toString() : "";
        %>
        <div class="chat-user <%= (targetUserId == (Integer)u.get("id")) ? "active" : "" %>"
             onclick="location.href='chat.jsp?userId=<%= u.get("id") %>'">
            <div class="user-circle"><%= firstInitial %></div>
            <div class="user-name">
                <div><%= uname %></div>
                <div class="last-msg"><%= lastMsg %></div>
            </div>
        </div>
        <% } %>
    </div>

    <div class="chat-area">
        <div class="chat-header">
            <%
                String targetName = "Select a user";
                if (targetUserId > 0) {
                    for (Map<String,Object> u : chatList) {
                        if (((Integer)u.get("id")) == targetUserId) {
                            targetName = u.get("username").toString();
                            break;
                        }
                    }
                }
                out.print(targetName);
            %>
        </div>

        <div class="chat-messages">
            <% if (messages.isEmpty() && targetUserId > 0) { %>
                <p style="text-align:center; color:#888;">No messages yet. Start the conversation!</p>
            <% } %>
            <% for(Map<String,Object> msg : messages) { 
                   boolean isMe = msg.get("sender").equals(username); %>
                <div class="message <%= isMe ? "you" : "not-you" %>">
                    <span class="sender"><%= msg.get("sender") %>:</span>
                    <span class="text"><%= msg.get("text") %></span>
                    <small>(<%= msg.get("time") %>)</small>
                </div>
            <% } %>
        </div>

        <% if (targetUserId > 0) { %>
        <div class="chat-input">
            <form method="post" action="chat.jsp">
                <input type="hidden" name="userId" value="<%= targetUserId %>">
                <input type="text" name="message" placeholder="Type a message...">
                <button type="submit">Send</button>
            </form>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>
