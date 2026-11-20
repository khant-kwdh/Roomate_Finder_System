<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if(username == null){ response.sendRedirect("login.jsp"); return; }

    // Get checkbox values; unchecked checkboxes return null
    boolean showEmail = request.getParameter("showEmail") != null;
    boolean showPhone = request.getParameter("showPhone") != null;
    boolean showProfile = request.getParameter("showProfile") != null;

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3308/roommatefinder","root","")) {
        String sql = "UPDATE users SET show_email=?, show_phone=?, show_profile=? WHERE username=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, showEmail);
            ps.setBoolean(2, showPhone);
            ps.setBoolean(3, showProfile);
            ps.setString(4, username);
            ps.executeUpdate();
        }
        response.sendRedirect("profile.jsp?success=Privacy settings updated successfully");
    } catch(Exception e){
        e.printStackTrace();
        response.sendRedirect("profile.jsp?error=Error updating privacy settings");
    }
%>
