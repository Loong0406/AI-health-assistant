package com.health.assistant.servlet;

import com.health.assistant.dao.PlanRecordDAO;
import com.health.assistant.dao.WeightRecordDAO;
import com.health.assistant.model.PlanRecord;
import com.health.assistant.model.User;
import com.health.assistant.model.WeightRecord;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class HistoryServlet extends HttpServlet {

    private WeightRecordDAO weightRecordDAO = new WeightRecordDAO();
    private PlanRecordDAO planRecordDAO = new PlanRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<WeightRecord> weightRecords = weightRecordDAO.findByUserId(user.getId());
        List<PlanRecord> planRecords = planRecordDAO.findByUserId(user.getId());

        request.setAttribute("weightRecords", weightRecords);
        request.setAttribute("planRecords", planRecords);
        request.getRequestDispatcher("/history.jsp").forward(request, response);
    }
}