<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.sql.*, com.roommatefinder.DBConnection" %>

<%
    // Check if admin is logged in
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");

    // Get complaint ID from request
    String idParam = request.getParameter("id");
    String resolveMessage = null;

    if (idParam != null) {
        int complaintId = Integer.parseInt(idParam);

        // Update complaint status in database
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE complaints SET status='resolved', resolved_at=NOW() WHERE id=?"
             )) {
            ps.setInt(1, complaintId);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                resolveMessage = "Complaint CMP" + complaintId + " has been successfully resolved.";
            } else {
                resolveMessage = "Error: Complaint CMP" + complaintId + " not found.";
            }
        } catch(Exception e) {
            resolveMessage = "Error: " + e.getMessage();
        }
    } else {
        resolveMessage = "Error: Complaint ID not provided.";
    }

    // After resolving, redirect back to adminDashboard.jsp with message
    session.setAttribute("resolveMessage", resolveMessage);
    response.sendRedirect("adminDashboard.jsp");
%>
