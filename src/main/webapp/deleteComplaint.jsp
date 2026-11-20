<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<%@ page import="java.sql.*, com.roommatefinder.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String complaintIdStr = request.getParameter("complaintId");
    if (complaintIdStr == null || complaintIdStr.isEmpty()) {
        response.sendRedirect("complain.jsp");
        return;
    }

    int complaintId = Integer.parseInt(complaintIdStr);

    try(Connection conn = DBConnection.getConnection();
        PreparedStatement pst = conn.prepareStatement(
            "DELETE FROM complaints WHERE id=? AND user_id=(SELECT id FROM users WHERE username=?)")) {
        pst.setInt(1, complaintId);
        pst.setString(2, username);
        int deleted = pst.executeUpdate();
        if(deleted > 0){
            // Successfully deleted
            response.sendRedirect("complain.jsp?msg=deleted");
        } else {
            // Complaint not found or does not belong to user
            response.sendRedirect("complain.jsp?msg=error");
        }
    } catch(Exception e){
        response.sendRedirect("complain.jsp?msg=error");
    }
%>
