package com.roommatefinder;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String occupation = request.getParameter("occupation");
        String location = request.getParameter("location");
        String budgetStr = request.getParameter("budget");
        String[] preferencesArr = request.getParameterValues("preferences");
        String terms = request.getParameter("terms");

        // Validation
        if (username == null || email == null || password == null ||
            ageStr == null || gender == null || occupation == null ||
            username.isEmpty() || email.isEmpty() || password.isEmpty() ||
            ageStr.isEmpty() || gender.isEmpty() || occupation.isEmpty() ||
            terms == null) {
            request.setAttribute("error", "All required fields must be filled and terms accepted.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        int age = Integer.parseInt(ageStr);
        double budget = (budgetStr != null && !budgetStr.isEmpty()) ? Double.parseDouble(budgetStr) : 0;
        String preferences = "";
        if (preferencesArr != null) {
            preferences = String.join(",", preferencesArr);
        }
        boolean termsAgreed = true;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users(username, email, password, age, gender, occupation, location, budget, preferences, terms_agreed, role) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?)"
            );
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password); // ⚠️ Use hashing in production!
            ps.setInt(4, age);
            ps.setString(5, gender);
            ps.setString(6, occupation);
            ps.setString(7, location);
            ps.setDouble(8, budget);
            ps.setString(9, preferences);
            ps.setBoolean(10, termsAgreed);
            ps.setString(11, "user");

            ps.executeUpdate();

            request.setAttribute("message", "Registration successful. Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
