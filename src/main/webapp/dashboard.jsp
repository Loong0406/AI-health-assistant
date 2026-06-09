<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.health.assistant.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的主页 - 智能健康助手</title>
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
                <span>欢迎，<%= user.getUsername() %></span>
            </div>
            <a href="logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                <span>退出登录</span>
            </a>
        </div>
    </nav>

    <div class="container">
        <div class="welcome-card">
            <h2>🌿 欢迎回来，<%= user.getUsername() %>！</h2>
            <p>让我们一起开启健康生活新方式，AI 将为您定制专属的饮食与运动计划 🌱</p>
        </div>

        <div class="features-grid">
            <div class="feature-card" onclick="location.href='health-profile'">
                <div class="card-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <h3>📋 健康档案</h3>
                <p>填写个人信息，让 AI 更懂您</p>
                <div class="card-arrow">
                    <span>立即填写</span>
                    <i class="fas fa-arrow-right"></i>
                </div>
            </div>

            <!-- 修改：点击跳转到确认页面，而不是直接生成 -->
            <div class="feature-card" onclick="location.href='confirm-plan.jsp'">
                <div class="card-icon">
                    <i class="fas fa-seedling"></i>
                </div>
                <h3>🌱 生成计划</h3>
                <p>AI 为您定制一周饮食运动计划</p>
                <div class="card-arrow">
                    <span>立即生成</span>
                    <i class="fas fa-arrow-right"></i>
                </div>
            </div>

            <div class="feature-card" onclick="location.href='weight-track'">
                <div class="card-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3>📊 体重追踪</h3>
                <p>记录体重，AI 动态调整建议</p>
                <div class="card-arrow">
                    <span>立即记录</span>
                    <i class="fas fa-arrow-right"></i>
                </div>
            </div>

            <div class="feature-card" onclick="location.href='history'">
                <div class="card-icon">
                    <i class="fas fa-history"></i>
                </div>
                <h3>📜 历史记录</h3>
                <p>查看体重变化和过往计划</p>
                <div class="card-arrow">
                    <span>立即查看</span>
                    <i class="fas fa-arrow-right"></i>
                </div>
            </div>
        </div>

        <div class="footer">
            <p>🌿 AI 智能健康助手 | 个性化饮食与运动规划 | 健康生活每一天 🌿</p>
        </div>
    </div>
</body>
</html>