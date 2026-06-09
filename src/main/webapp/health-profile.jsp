<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.health.assistant.model.User, com.health.assistant.model.HealthProfile" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    HealthProfile profile = (HealthProfile) request.getAttribute("profile");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>健康档案 - 智能健康助手</title>
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

    <div class="container-sm">
        <div class="form-card">
            <div class="form-header">
                <h2>📋 健康档案</h2>
                <p>填写您的个人信息，让 AI 更了解您</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
            <% } %>

            <form action="health-profile" method="post">
                <div class="form-group">
                    <label><i class="fas fa-calendar-alt"></i> 年龄</label>
                    <input type="number" name="age" value="<%= profile != null ? profile.getAge() : "" %>" placeholder="请输入年龄" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-venus-mars"></i> 性别</label>
                    <select name="gender" required>
                        <option value="">请选择</option>
                        <option value="男" <%= profile != null && "男".equals(profile.getGender()) ? "selected" : "" %>>男</option>
                        <option value="女" <%= profile != null && "女".equals(profile.getGender()) ? "selected" : "" %>>女</option>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-ruler"></i> 身高 (cm)</label>
                    <input type="number" step="0.01" name="height" value="<%= profile != null ? profile.getHeight() : "" %>" placeholder="请输入身高" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-weight-scale"></i> 体重 (kg)</label>
                    <input type="number" step="0.1" name="weight" value="<%= profile != null ? profile.getWeight() : "" %>" placeholder="请输入体重" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-running"></i> 活动水平</label>
                    <select name="activityLevel" required>
                        <option value="">请选择</option>
                        <option value="低" <%= profile != null && "低".equals(profile.getActivityLevel()) ? "selected" : "" %>>低（久坐为主）</option>
                        <option value="中" <%= profile != null && "中".equals(profile.getActivityLevel()) ? "selected" : "" %>>中（适度运动）</option>
                        <option value="高" <%= profile != null && "高".equals(profile.getActivityLevel()) ? "selected" : "" %>>高（经常运动）</option>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-utensils"></i> 饮食偏好</label>
                    <select name="dietPreference" required>
                        <option value="">请选择</option>
                        <option value="均衡" <%= profile != null && "均衡".equals(profile.getDietPreference()) ? "selected" : "" %>>均衡</option>
                        <option value="素食" <%= profile != null && "素食".equals(profile.getDietPreference()) ? "selected" : "" %>>素食</option>
                        <option value="高蛋白" <%= profile != null && "高蛋白".equals(profile.getDietPreference()) ? "selected" : "" %>>高蛋白</option>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-bullseye"></i> 健康目标</label>
                    <select name="healthGoal" required>
                        <option value="">请选择</option>
                        <option value="减肥" <%= profile != null && "减肥".equals(profile.getHealthGoal()) ? "selected" : "" %>>减肥</option>
                        <option value="增肌" <%= profile != null && "增肌".equals(profile.getHealthGoal()) ? "selected" : "" %>>增肌</option>
                        <option value="保持健康" <%= profile != null && "保持健康".equals(profile.getHealthGoal()) ? "selected" : "" %>>保持健康</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-save"></i> 保存档案
                </button>
            </form>

            <a href="dashboard.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> 返回首页
            </a>
        </div>
    </div>
</body>
</html>