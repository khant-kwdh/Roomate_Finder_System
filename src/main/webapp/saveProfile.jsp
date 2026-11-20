<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if(username == null){ response.sendRedirect("login.jsp"); return; }

    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String ageStr = request.getParameter("age");
    String gender = request.getParameter("gender");
    String major = request.getParameter("major");
    String bio = request.getParameter("bio");

    int age = 0;
    try { age = Integer.parseInt(ageStr); } catch(Exception e){}

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3308/roommatefinder","root","")) {
        String sql = "UPDATE users SET first_name=?, last_name=?, email=?, phone=?, age=?, gender=?, major=?, bio=? WHERE username=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setInt(5, age);
            ps.setString(6, gender);
            ps.setString(7, major);
            ps.setString(8, bio);
            ps.setString(9, username);
            ps.executeUpdate();
        }
        response.sendRedirect("profile.jsp?success=Profile updated successfully");
    } catch(Exception e){
        e.printStackTrace();
        response.sendRedirect("profile.jsp?error=Error updating profile");
    }
%>
