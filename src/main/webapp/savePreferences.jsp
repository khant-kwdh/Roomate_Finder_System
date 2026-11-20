<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if(username == null){ response.sendRedirect("login.jsp"); return; }

    String cleanliness = request.getParameter("cleanliness");
    String sleepSchedule = request.getParameter("sleepSchedule");
    String smoking = request.getParameter("smoking");
    String overnightGuests = request.getParameter("overnightGuests");

    String preferredGender = request.getParameter("preferredGender");
    String ageMinStr = request.getParameter("ageMin");
    String ageMaxStr = request.getParameter("ageMax");
    String budgetStr = request.getParameter("budget");
    String location = request.getParameter("location");
    String mustHave = request.getParameter("mustHave"); // comma-separated string

    int ageMin = 18, ageMax = 99;
    double budget = 0;
    try { ageMin = Integer.parseInt(ageMinStr); } catch(Exception e){}
    try { ageMax = Integer.parseInt(ageMaxStr); } catch(Exception e){}
    try { budget = Double.parseDouble(budgetStr); } catch(Exception e){}

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3308/roommatefinder","root","")) {
        String sql = "UPDATE users SET cleanliness=?, sleep_schedule=?, smoking=?, overnight_guests=?, preferred_gender=?, age_min=?, age_max=?, budget=?, location=?, must_have=? WHERE username=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cleanliness);
            ps.setString(2, sleepSchedule);
            ps.setString(3, smoking);
            ps.setString(4, overnightGuests);
            ps.setString(5, preferredGender);
            ps.setInt(6, ageMin);
            ps.setInt(7, ageMax);
            ps.setDouble(8, budget);
            ps.setString(9, location);
            ps.setString(10, mustHave);
            ps.setString(11, username);
            ps.executeUpdate();
        }
        response.sendRedirect("profile.jsp?success=Preferences updated successfully");
    } catch(Exception e){
        e.printStackTrace();
        response.sendRedirect("profile.jsp?error=Error updating preferences");
    }
%>
