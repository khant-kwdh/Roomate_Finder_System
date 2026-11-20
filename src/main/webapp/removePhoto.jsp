<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) { response.sendRedirect("login.jsp"); return; }

    Connection conn = null; PreparedStatement ps = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3308/roommatefinder","root","");
        ps = conn.prepareStatement("UPDATE users SET profile_photo=NULL WHERE username=?");
        ps.setString(1, username);
        ps.executeUpdate();
    } catch(Exception e){ e.printStackTrace(); }
    finally { if(ps!=null) ps.close(); if(conn!=null) conn.close(); }

    response.sendRedirect("profile.jsp?success=Photo removed successfully");
%>
