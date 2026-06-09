<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 智能健康助手</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container-sm">
        <div class="form-card">
            <div class="form-header">
                <h2>🔐 登录</h2>
                <p>欢迎回来，请登录您的账号</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("message") != null) { %>
                <div class="success"><i class="fas fa-check-circle"></i> <%= request.getAttribute("message") %></div>
            <% } %>

            <form action="login" method="post">
                <div class="form-group">
                    <label><i class="fas fa-user"></i> 用户名</label>
                    <input type="text" name="username" placeholder="请输入用户名" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-lock"></i> 密码</label>
                    <input type="password" name="password" placeholder="请输入密码" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">登录</button>
            </form>

            <div style="text-align: center; margin-top: 25px; color: var(--text-secondary);">
                还没有账号？ <a href="register.jsp" style="color: var(--primary-2); text-decoration: none; font-weight: 500;">立即注册</a>
            </div>
        </div>
    </div>
</body>
</html>