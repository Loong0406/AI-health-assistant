package com.health.assistant.servlet;

import com.health.assistant.dao.HealthProfileDAO;
import com.health.assistant.dao.PlanRecordDAO;
import com.health.assistant.dao.WeightRecordDAO;
import com.health.assistant.model.HealthProfile;
import com.health.assistant.model.PlanRecord;
import com.health.assistant.model.User;
import com.health.assistant.model.WeightRecord;
import com.health.assistant.util.OllamaUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class GeneratePlanServlet extends HttpServlet {

    private HealthProfileDAO profileDAO = new HealthProfileDAO();
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

        // 检查是否有健康档案
        HealthProfile profile = profileDAO.findByUserId(user.getId());
        if (profile == null) {
            response.sendRedirect("health-profile");
            return;
        }

        // 获取历史体重记录
        List<WeightRecord> weightRecords = weightRecordDAO.findByUserId(user.getId());

        // 构建 AI Prompt
        String prompt = buildPrompt(profile, weightRecords);

        // 调用 Ollama AI 生成计划
        String aiResponse = OllamaUtil.generate("deepseek-r1:7b", prompt);

        // 解析 AI 返回的内容
        String dietPlan = extractDietPlan(aiResponse);
        String exercisePlan = extractExercisePlan(aiResponse);

        // 保存计划到数据库
        PlanRecord planRecord = new PlanRecord();
        planRecord.setUserId(user.getId());
        planRecord.setWeekStart(getWeekStartDate());
        planRecord.setDietPlan(dietPlan);
        planRecord.setExercisePlan(exercisePlan);
        planRecordDAO.save(planRecord);

        // 返回结果
        request.setAttribute("dietPlan", dietPlan);
        request.setAttribute("exercisePlan", exercisePlan);
        request.getRequestDispatcher("/view-plan.jsp").forward(request, response);
    }

    private String buildPrompt(HealthProfile profile, List<WeightRecord> weightRecords) {
        StringBuilder sb = new StringBuilder();
        sb.append("你是一名专业的健康管理师。请根据以下用户信息，生成一份详细的、以周为单位的饮食和运动计划。\n\n");
        sb.append("### 用户基本信息 ###\n");
        sb.append("- 年龄：").append(profile.getAge()).append("岁\n");
        sb.append("- 性别：").append(profile.getGender()).append("\n");
        sb.append("- 身高：").append(profile.getHeight()).append(" cm\n");
        sb.append("- 当前体重：").append(profile.getWeight()).append(" kg\n");
        sb.append("- 活动水平：").append(profile.getActivityLevel()).append("\n");
        sb.append("- 饮食偏好：").append(profile.getDietPreference()).append("\n");
        sb.append("- 健康目标：").append(profile.getHealthGoal()).append("\n\n");

        // 增强：体重变化趋势分析
        if (weightRecords != null && weightRecords.size() >= 2) {
            sb.append("### 历史体重变化趋势（用于优化计划）###\n");

            // 显示所有体重记录
            for (WeightRecord record : weightRecords) {
                sb.append("- ").append(record.getRecordDate()).append("：").append(record.getWeight()).append(" kg\n");
            }

            // 计算趋势
            WeightRecord first = weightRecords.get(0);
            WeightRecord last = weightRecords.get(weightRecords.size() - 1);
            double totalChange = last.getWeight().doubleValue() - first.getWeight().doubleValue();

            sb.append("\n### 趋势分析 ###\n");
            if (totalChange < -1.0) {
                sb.append("⚠️ 警告：用户体重下降较快（").append(String.format("%.1f", -totalChange)).append(" kg），请适当增加热量摄入，避免过度减重影响健康。\n");
            } else if (totalChange > 0.5) {
                sb.append("⚠️ 注意：用户体重有所上升（+").append(String.format("%.1f", totalChange)).append(" kg），需要加强运动和控制饮食。\n");
            } else if (Math.abs(totalChange) < 0.3 && weightRecords.size() >= 3) {
                sb.append("📌 提示：用户体重进入平台期，建议调整运动方式和饮食结构来突破瓶颈。\n");
            } else if (totalChange < 0) {
                sb.append("✅ 用户体重稳步下降，继续保持当前节奏。\n");
            }

            sb.append("\n请根据以上体重变化趋势，针对性地调整本周的饮食和运动计划。\n\n");
        }

        sb.append("### 输出格式要求 ###\n");
        sb.append("请严格按照以下两部分输出：\n\n");
        sb.append("【饮食计划】\n");
        sb.append("（周一至周日每日三餐详细安排，结合用户的饮食偏好和健康目标）\n\n");
        sb.append("【运动计划】\n");
        sb.append("（周一至周日每日运动详细安排，结合用户的活动水平和健康目标）\n");

        return sb.toString();
    }

    private String extractDietPlan(String aiResponse) {
        if (aiResponse == null) return "AI 生成失败，请重试";
        int start = aiResponse.indexOf("【饮食计划】");
        int end = aiResponse.indexOf("【运动计划】");
        if (start != -1 && end != -1) {
            return aiResponse.substring(start + 6, end).trim();
        }
        // 如果没有找到标记，尝试直接返回
        if (aiResponse.length() > 500) {
            return aiResponse.substring(0, Math.min(aiResponse.length() / 2, 500));
        }
        return "饮食计划生成失败，请重新生成";
    }

    private String extractExercisePlan(String aiResponse) {
        if (aiResponse == null) return "AI 生成失败，请重试";
        int start = aiResponse.indexOf("【运动计划】");
        if (start != -1) {
            return aiResponse.substring(start + 6).trim();
        }
        return "运动计划生成失败，请重新生成";
    }

    private Date getWeekStartDate() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        return cal.getTime();
    }
}