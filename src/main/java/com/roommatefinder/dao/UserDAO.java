package com.roommatefinder.dao;

import com.roommatefinder.DBConnection;
import com.roommatefinder.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Fetch all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching all users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    // Fetch pending users
    public List<User> getPendingUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE status='pending' ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching pending users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    // Approve a user
    public boolean approveUser(int userId) {
        return updateUserStatus(userId, "approved");
    }

    // Reject a user
    public boolean rejectUser(int userId) {
        return updateUserStatus(userId, "rejected");
    }

    // Update user info
    public boolean updateUser(int id, String username, String email, String role, String status) {
        String sql = "UPDATE users SET username=?, email=?, role=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, role);
            ps.setString(4, status != null ? status : "pending"); // default if null
            ps.setInt(5, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user (ID=" + id + "): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get user by ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching user by ID (" + id + "): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Private helper to update status
    private boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status != null ? status : "pending");
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user status (ID=" + userId + "): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Map ResultSet to User object safely
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username") != null ? rs.getString("username") : "Unknown");
        user.setEmail(rs.getString("email") != null ? rs.getString("email") : "");
        user.setRole(rs.getString("role") != null ? rs.getString("role") : "user");

        String status = rs.getString("status");
        if (status == null || status.isEmpty()) status = "pending";
        user.setStatus(status);

        Timestamp createdAt = rs.getTimestamp("created_at");
        user.setCreatedAt(createdAt != null ? createdAt : new Timestamp(System.currentTimeMillis()));

        return user;
    }
}
