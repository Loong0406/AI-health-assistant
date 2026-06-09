package com.health.assistant.servlet;

import com.health.assistant.dao.HealthProfileDAO;
import com.health.assistant.model.HealthProfile;
import com.health.assistant.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

public class HealthProfileServlet extends HttpServlet {

    private HealthProfileDAO profileDAO = new HealthProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        HealthProfile profile = profileDAO.findByUserId(user.getId());
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/health-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        HealthProfile profile = new HealthProfile();
        profile.setUserId(user.getId());
        profile.setAge(Integer.parseInt(request.getParameter("age")));
        profile.setGender(request.getParameter("gender"));
        profile.setHeight(new BigDecimal(request.getParameter("height")));
        profile.setWeight(new BigDecimal(request.getParameter("weight")));
        profile.setActivityLevel(request.getParameter("activityLevel"));
        profile.setDietPreference(request.getParameter("dietPreference"));
        profile.setHealthGoal(request.getParameter("healthGoal"));

        if (profileDAO.saveOrUpdate(profile)) {
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("error", "保存失败，请重试！");
            request.getRequestDispatcher("/health-profile.jsp").forward(request, response);
        }
    }
}