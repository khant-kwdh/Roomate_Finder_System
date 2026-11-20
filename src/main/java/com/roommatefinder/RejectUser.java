package com.roommatefinder;

import com.roommatefinder.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/rejectUser")
public class RejectUser extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                UserDAO dao = new UserDAO();
                boolean success = dao.rejectUser(id);

                if(success) {
                    request.getSession().setAttribute("message", "User rejected successfully.");
                } else {
                    request.getSession().setAttribute("error", "Failed to reject user.");
                }

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Invalid user ID.");
            }
        }
        response.sendRedirect("manageUsers.jsp");
    }
}
