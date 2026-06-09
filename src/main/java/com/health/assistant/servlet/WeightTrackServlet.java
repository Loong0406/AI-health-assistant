package com.health.assistant.servlet;

import com.health.assistant.dao.WeightRecordDAO;
import com.health.assistant.model.User;
import com.health.assistant.model.WeightRecord;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class WeightTrackServlet extends HttpServlet {

    private WeightRecordDAO weightRecordDAO = new WeightRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<WeightRecord> records = weightRecordDAO.findByUserId(user.getId());
        WeightRecord latest = weightRecordDAO.getLatest(user.getId());

        // 分析体重变化趋势
        String trendMessage = analyzeWeightTrend(records);

        request.setAttribute("weightRecords", records);
        request.setAttribute("latest", latest);
        request.setAttribute("trendMessage", trendMessage);
        request.getRequestDispatcher("/weight-track.jsp").forward(request, response);
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

        String weightStr = request.getParameter("weight");
        String recordDateStr = request.getParameter("recordDate");

        try {
            BigDecimal weight = new BigDecimal(weightStr);
            Date recordDate = new SimpleDateFormat("yyyy-MM-dd").parse(recordDateStr);

            WeightRecord record = new WeightRecord();
            record.setUserId(user.getId());
            record.setWeight(weight);
            record.setRecordDate(recordDate);

            if (weightRecordDAO.add(record)) {
                response.sendRedirect("weight-track");
            } else {
                request.setAttribute("error", "保存失败，请重试！");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "数据格式错误！");
            doGet(request, response);
        }
    }

    /**
     * 分析体重变化趋势
     * @param records 历史体重记录列表
     * @return 趋势分析文本
     */
    private String analyzeWeightTrend(List<WeightRecord> records) {
        if (records == null || records.size() < 2) {
            return "📝 暂无足够的体重数据进行分析。请继续每周记录体重，系统将为您提供个性化建议。";
        }

        StringBuilder analysis = new StringBuilder();

        // 计算总体变化
        WeightRecord first = records.get(0);
        WeightRecord last = records.get(records.size() - 1);
        double totalChange = last.getWeight().doubleValue() - first.getWeight().doubleValue();
        int weeksCount = records.size() - 1;
        double weeklyAvgChange = totalChange / weeksCount;

        // 分析最近两周的变化
        double recentChange = 0;
        if (records.size() >= 2) {
            WeightRecord recent = records.get(records.size() - 1);
            WeightRecord previous = records.get(records.size() - 2);
            recentChange = recent.getWeight().doubleValue() - previous.getWeight().doubleValue();
        }

        analysis.append("📊 体重变化分析：\n");
        analysis.append("• 记录周期：").append(weeksCount).append(" 周\n");
        analysis.append("• 总体变化：");
        if (totalChange < 0) {
            analysis.append("下降 ").append(String.format("%.1f", -totalChange)).append(" kg ✅\n");
        } else if (totalChange > 0) {
            analysis.append("上升 ").append(String.format("%.1f", totalChange)).append(" kg ⚠️\n");
        } else {
            analysis.append("保持稳定 📌\n");
        }

        analysis.append("• 平均每周变化：");
        if (weeklyAvgChange < 0) {
            analysis.append("下降 ").append(String.format("%.1f", -weeklyAvgChange)).append(" kg/周\n");
        } else if (weeklyAvgChange > 0) {
            analysis.append("上升 ").append(String.format("%.1f", weeklyAvgChange)).append(" kg/周\n");
        } else {
            analysis.append("0 kg/周\n");
        }

        // 给出建议
        analysis.append("\n💡 AI 智能建议：\n");

        if (totalChange < -1.5 && weeksCount <= 2) {
            analysis.append("• 体重下降较快，请确保营养摄入充足，不要过度节食。\n");
        } else if (totalChange > 0.5 && weeksCount >= 2) {
            analysis.append("• 体重有所上升，建议增加运动量并注意饮食控制。\n");
        } else if (Math.abs(recentChange) < 0.3 && records.size() >= 3) {
            analysis.append("• 体重进入平台期，建议调整运动方式或饮食结构。\n");
        } else if (weeklyAvgChange < -0.3 && weeklyAvgChange > -0.8) {
            analysis.append("• 减重速度理想，继续保持！\n");
        } else if (weeklyAvgChange < -0.8) {
            analysis.append("• 减重速度偏快，请关注身体感受，确保健康第一。\n");
        } else {
            analysis.append("• 继续坚持健康的生活方式，AI 将为您优化新一周的计划。\n");
        }

        return analysis.toString();
    }
}