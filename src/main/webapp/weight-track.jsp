<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.health.assistant.model.User, com.health.assistant.model.WeightRecord, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<WeightRecord> records = (List<WeightRecord>) request.getAttribute("weightRecords");
    WeightRecord latest = (WeightRecord) request.getAttribute("latest");
    String trendMessage = (String) request.getAttribute("trendMessage");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>体重追踪 - 智能健康助手</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        <!-- 当前体重卡片 -->
        <div class="card">
            <h2>📊 当前体重</h2>
            <% if (latest != null) { %>
                <div class="current-weight"><%= latest.getWeight() %> kg</div>
                <div>记录日期：<%= latest.getRecordDate() %></div>
            <% } else { %>
                <div style="color: #999;">暂无体重记录，请添加第一条记录</div>
            <% } %>
        </div>

        <!-- 趋势分析卡片 -->
        <% if (trendMessage != null && !trendMessage.isEmpty()) { %>
        <div class="card">
            <h2>📈 体重趋势分析</h2>
            <div class="trend-message">
                <%= trendMessage.replace("\n", "<br>") %>
            </div>
        </div>
        <% } %>

        <!-- 添加体重记录卡片 -->
        <div class="card">
            <h2>➕ 记录新体重</h2>
            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>
            <form action="weight-track" method="post">
                <div class="form-group">
                    <label>体重 (kg)</label>
                    <input type="number" step="0.1" name="weight" required>
                </div>
                <div class="form-group">
                    <label>记录日期</label>
                    <input type="date" name="recordDate" required>
                </div>
                <div style="display: flex; gap: 15px;">
                    <button type="submit" class="btn btn-primary">保存记录</button>
                    <a href="generate-plan" class="btn btn-primary" style="background: var(--accent-success);">🔄 基于新体重重新生成计划</a>
                </div>
            </form>
        </div>

        <!-- 历史体重记录卡片 -->
        <div class="card">
            <h2>📜 历史体重记录</h2>
            <% if (records != null && !records.isEmpty()) { %>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>日期</th>
                                <th>体重 (kg)</th>
                                <th>变化</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Double previousWeight = null;
                                for (int i = 0; i < records.size(); i++) {
                                    WeightRecord record = records.get(i);
                                    double current = record.getWeight().doubleValue();
                                    String change = "";
                                    String changeClass = "";
                                    if (previousWeight != null) {
                                        double diff = current - previousWeight;
                                        if (diff > 0) {
                                            change = "+" + String.format("%.1f", diff);
                                            changeClass = "trend-up";
                                        } else if (diff < 0) {
                                            change = String.format("%.1f", diff);
                                            changeClass = "trend-down";
                                        } else {
                                            change = "0";
                                            changeClass = "trend-stable";
                                        }
                                    }
                                    previousWeight = current;
                            %>
                            <tr>
                                <td><%= record.getRecordDate() %></td>
                                <td><%= record.getWeight() %> kg</td>
                                <td class="<%= changeClass %>"><%= change %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- 体重变化图表 -->
                <div class="chart-container">
                    <canvas id="weightChart"></canvas>
                </div>
                <script>
                    const dates = [<% for (WeightRecord r : records) { %>'<%= r.getRecordDate() %>',<% } %>];
                    const weights = [<% for (WeightRecord r : records) { %><%= r.getWeight() %>,<% } %>];
                    const ctx = document.getElementById('weightChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: dates,
                            datasets: [{
                                label: '体重 (kg)',
                                data: weights,
                                borderColor: '#4CAF92',
                                backgroundColor: 'rgba(76, 175, 146, 0.1)',
                                tension: 0.3,
                                fill: true
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: true,
                            plugins: {
                                legend: { position: 'top' }
                            }
                        }
                    });
                </script>
            <% } else { %>
                <p>暂无历史记录</p>
            <% } %>
        </div>

        <a href="dashboard.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> 返回首页
        </a>
    </div>
</body>
</html>