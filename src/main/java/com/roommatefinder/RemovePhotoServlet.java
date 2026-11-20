package com.roommatefinder;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.*;

@WebServlet("/removePhoto")
public class RemovePhotoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DriverManager.getConnection(
                     "jdbc:mysql://127.0.0.1:3308/roommatefinder","root","");
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT profile_photo FROM users WHERE username=?")) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String path = rs.getString("profile_photo");
                if (path != null && !path.isEmpty()) {
                    String fullPath = getServletContext().getRealPath("") + File.separator + path;
                    File file = new File(fullPath);
                    if (file.exists()) file.delete();
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // Remove path from DB
        try (Connection conn = DriverManager.getConnection(
                     "jdbc:mysql://127.0.0.1:3308/roommatefinder","root","");
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE users SET profile_photo=NULL WHERE username=?")) {
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }

        response.sendRedirect("profile.jsp?success=Photo removed successfully");
    }
}

