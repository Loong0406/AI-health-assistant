package com.health.assistant.servlet;

import com.health.assistant.dao.UserDAO;
import com.health.assistant.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 验证两次密码是否一致
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致！");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 检查用户名是否已存在
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "用户名已存在，请选择其他用户名！");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 注册新用户
        User user = new User(username, password);
        if (userDAO.register(user)) {
            request.setAttribute("message", "注册成功，请登录！");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "注册失败，请稍后重试！");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }
}