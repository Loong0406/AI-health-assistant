<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.health.assistant.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String dietPlan = (String) request.getAttribute("dietPlan");
    String exercisePlan = (String) request.getAttribute("exercisePlan");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI 健康计划 - 智能健康助手</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="logo" onclick="location.href='dashboard.jsp'">
            <div class="logo-icon">
                <i class="fas fa-leaf"></i>
            </div>
            <h1>智能健康助手</h1>
        </div>
        <div class="user-info">
            <div class="user-name">
                <i class="fas fa-user-circle"></i>
                <span><%= user.getUsername() %></span>
            </div>
            <a href="logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                <span>退出</span>
            </a>
        </div>
    </nav>

    <div class="container">
        <div class="welcome-card" style="margin-bottom: 30px;">
            <h2>🤖 AI 智能计划</h2>
            <p>基于您的健康档案，AI 为您量身定制的饮食与运动方案</p>
        </div>

        <div class="plan-container">
            <div class="plan-card">
                <h2><i class="fas fa-apple-alt"></i> 🥗 饮食计划</h2>
                <div class="plan-content">
                    <%= dietPlan != null ? dietPlan.replace("\n", "<br>") : "暂无计划，请先填写健康档案" %>
                </div>
            </div>
            <div class="plan-card">
                <h2><i class="fas fa-dumbbell"></i> 🏃 运动计划</h2>
                <div class="plan-content">
                    <%= exercisePlan != null ? exercisePlan.replace("\n", "<br>") : "暂无计划，请先填写健康档案" %>
                </div>
            </div>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="dashboard.jsp" class="btn btn-primary">返回首页</a>
        </div>
    </div>
</body>
</html>