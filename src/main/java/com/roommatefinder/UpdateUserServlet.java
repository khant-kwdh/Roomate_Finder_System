package com.roommatefinder;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.roommatefinder.dao.UserDAO;

@WebServlet("/updateUser")
public class UpdateUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        UserDAO dao = new UserDAO();
        boolean success = dao.updateUser(id, username, email, role, status);

        if(success) {
            response.sendRedirect("manageUsers.jsp");
        } else {
            request.setAttribute("error", "Failed to update user.");
            request.getRequestDispatcher("editUser.jsp?id=" + id).forward(request, response);
        }
    }
}
