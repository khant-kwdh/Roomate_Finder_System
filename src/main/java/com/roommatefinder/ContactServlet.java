package com.roommatefinder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Save contact message to database
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO contact_messages(name, email, subject, message) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, subject);
                ps.setString(4, message);
                ps.executeUpdate();
            }

            request.setAttribute("success", "✅ Your message has been sent!");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Failed to send message: " + e.getMessage());
        }

        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }
}
