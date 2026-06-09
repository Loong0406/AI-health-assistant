<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.health.assistant.model.User, com.health.assistant.model.HealthProfile" %>
<%@ page import="com.health.assistant.dao.HealthProfileDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    HealthProfileDAO profileDAO = new HealthProfileDAO();
    HealthProfile profile = profileDAO.findByUserId(user.getId());

    boolean hasProfile = (profile != null);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>确认生成计划 - 智能健康助手</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .confirm-card {
            max-width: 600px;
            margin: 60px auto;
            text-align: center;
        }
        .info-box {
            background: rgba(76, 175, 146, 0.1);
            border-radius: 20px;
            padding: 25px;
            margin: 30px 0;
            text-align: left;
        }
        .info-box p {
            margin: 10px 0;
            color: var(--text-secondary);
        }
        .warning-box {
            background: rgba(255, 183, 77, 0.15);
            border-left: 4px solid var(--accent-warning);
            padding: 15px 20px;
            border-radius: 12px;
            margin: 20px 0;
            text-align: left;
        }
        .btn-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 30px;
        }
        .btn-cancel {
            background: #e0e0e0;
            color: #666;
        }
        .btn-cancel:hover {
            background: #ccc;
            transform: translateY(-2px);
        }
        .no-profile {
            background: rgba(239, 83, 80, 0.1);
            border-left: 4px solid var(--accent-danger);
            padding: 20px;
            border-radius: 16px;
            margin: 20px 0;
        }
    </style>
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
        <div class="confirm-card">
            <div class="form-card">
                <div class="form-header">
                    <h2>🤖 确认生成 AI 计划</h2>
                    <p>请确认以下信息后，AI 将为您生成个性化方案</p>
                </div>

                <% if (!hasProfile) { %>
                    <div class="no-profile">
                        <i class="fas fa-exclamation-triangle" style="color: var(--accent-danger); font-size: 24px; margin-bottom: 10px; display: block;"></i>
                        <strong>⚠️ 您还没有填写健康档案</strong>
                        <p style="margin-top: 10px;">AI 需要了解您的个人信息才能生成个性化计划。</p>
                        <a href="health-profile" class="btn btn-primary" style="margin-top: 15px; display: inline-block;">📋 立即填写健康档案</a>
                    </div>
                    <a href="dashboard.jsp" class="back-link">
                        <i class="fas fa-arrow-left"></i> 返回首页
                    </a>
                <% } else { %>
                    <div class="info-box">
                        <h3 style="color: var(--primary-1); margin-bottom: 15px;">📋 当前健康档案</h3>
                        <p><strong>年龄：</strong><%= profile.getAge() %> 岁</p>
                        <p><strong>性别：</strong><%= profile.getGender() %></p>
                        <p><strong>身高：</strong><%= profile.getHeight() %> cm</p>
                        <p><strong>体重：</strong><%= profile.getWeight() %> kg</p>
                        <p><strong>活动水平：</strong><%= profile.getActivityLevel() %></p>
                        <p><strong>饮食偏好：</strong><%= profile.getDietPreference() %></p>
                        <p><strong>健康目标：</strong><%= profile.getHealthGoal() %></p>
                    </div>

                    <div class="warning-box">
                        <i class="fas fa-info-circle" style="color: var(--accent-warning); margin-right: 10px;"></i>
                        <strong>温馨提示：</strong>
                        <p style="margin-top: 8px; font-size: 14px;">AI 将根据您的健康档案和近期体重变化趋势，生成一份为期一周的饮食和运动计划。生成过程可能需要 5-15 秒，请耐心等待。</p>
                    </div>

                    <div class="btn-group">
                        <a href="dashboard.jsp" class="btn btn-cancel">
                            <i class="fas fa-times"></i> 取消
                        </a>
                        <a href="generate-plan" class="btn btn-primary">
                            <i class="fas fa-check"></i> 确认生成
                        </a>
                    </div>

                    <a href="dashboard.jsp" class="back-link">
                        <i class="fas fa-arrow-left"></i> 返回首页
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>