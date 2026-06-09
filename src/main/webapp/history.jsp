<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.health.assistant.model.User, com.health.assistant.model.WeightRecord, com.health.assistant.model.PlanRecord, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<WeightRecord> weightRecords = (List<WeightRecord>) request.getAttribute("weightRecords");
    List<PlanRecord> planRecords = (List<PlanRecord>) request.getAttribute("planRecords");

    // 获取查询参数
    String searchYear = request.getParameter("year");
    String searchMonth = request.getParameter("month");
    String searchDate = request.getParameter("date");

    // 过滤计划记录（使用传统方式，兼容低版本Java）
    List<PlanRecord> filteredPlans = new ArrayList<PlanRecord>();
    if (planRecords != null && !planRecords.isEmpty()) {
        for (PlanRecord plan : planRecords) {
            boolean match = true;
            java.util.Date weekStart = plan.getWeekStart();
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(weekStart);
            int planYear = cal.get(java.util.Calendar.YEAR);
            int planMonth = cal.get(java.util.Calendar.MONTH) + 1;
            String planDateStr = weekStart.toString().substring(0, 10);

            if (searchDate != null && !searchDate.isEmpty()) {
                if (!planDateStr.equals(searchDate)) {
                    match = false;
                }
            } else if (searchYear != null && !searchYear.isEmpty()) {
                int yearFilter = Integer.parseInt(searchYear);
                if (planYear != yearFilter) {
                    match = false;
                }
                if (searchMonth != null && !searchMonth.isEmpty()) {
                    int monthFilter = Integer.parseInt(searchMonth);
                    if (planMonth != monthFilter) {
                        match = false;
                    }
                }
            } else if (searchMonth != null && !searchMonth.isEmpty()) {
                int monthFilter = Integer.parseInt(searchMonth);
                if (planMonth != monthFilter) {
                    match = false;
                }
            }

            if (match) {
                filteredPlans.add(plan);
            }
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>历史记录 - 智能健康助手</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .search-bar {
            background: white;
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-md);
        }
        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }
        .search-group {
            flex: 1;
            min-width: 150px;
        }
        .search-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-secondary);
        }
        .search-group select, .search-group input {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
        }
        .search-group select:focus, .search-group input:focus {
            outline: none;
            border-color: var(--primary-2);
        }
        .search-btn {
            background: linear-gradient(135deg, var(--primary-1) 0%, var(--primary-2) 100%);
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        .reset-btn {
            background: #e0e0e0;
            color: #666;
            border: none;
            padding: 10px 24px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .reset-btn:hover {
            background: #ccc;
        }
        .filter-info {
            background: rgba(76, 175, 146, 0.1);
            border-radius: 12px;
            padding: 10px 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .result-count {
            font-size: 14px;
            color: var(--primary-1);
            font-weight: 500;
        }
        .no-result {
            text-align: center;
            padding: 40px;
            color: var(--text-secondary);
        }
        .plan-item {
            background: #f8f9fa;
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .plan-item:hover {
            box-shadow: var(--shadow-md);
        }
        .plan-date {
            font-weight: 700;
            color: var(--primary-1);
            margin-bottom: 12px;
            font-size: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .plan-date-left {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            align-items: center;
        }
        .plan-badge {
            background: rgba(76, 175, 146, 0.15);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: normal;
            color: var(--primary-1);
            cursor: pointer;
        }
        .plan-badge:hover {
            background: rgba(76, 175, 146, 0.3);
        }
        .plan-time {
            font-size: 13px;
            font-weight: normal;
            color: var(--text-secondary);
        }
        .plan-content {
            white-space: pre-wrap;
            font-family: inherit;
            line-height: 1.7;
            color: var(--text-secondary);
            font-size: 14px;
            max-height: 300px;
            overflow-y: auto;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 20px;
            color: var(--primary-2);
            text-decoration: none;
            font-weight: 500;
        }
        .back-link:hover {
            gap: 12px;
            color: var(--primary-1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e8e8e8;
        }
        th {
            background: #f8f9fa;
            color: var(--primary-1);
        }
        .card {
            background: white;
            border-radius: 24px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-md);
        }
        .card h2 {
            margin-bottom: 20px;
            color: var(--primary-1);
        }
        .welcome-card {
            background: linear-gradient(135deg, var(--primary-1) 0%, var(--primary-2) 100%);
            border-radius: 32px;
            padding: 30px;
            color: white;
        }
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 0 40px;
            height: 70px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
        }
        .logo-icon {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, var(--primary-1) 0%, var(--primary-2) 100%);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .logo-icon i {
            color: white;
            font-size: 20px;
        }
        .logo h1 {
            font-size: 22px;
            background: linear-gradient(135deg, var(--primary-1) 0%, var(--primary-2) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .user-name {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--primary-1);
        }
        .logout-btn {
            background: linear-gradient(135deg, var(--primary-1) 0%, var(--primary-2) 100%);
            color: white;
            text-decoration: none;
            padding: 8px 20px;
            border-radius: 30px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }
    </style>
    <script>
        function filterByYear() {
            var year = document.getElementById('year').value;
            var month = document.getElementById('month').value;
            var date = document.getElementById('date').value;
            var url = 'history?';
            if (year) url += 'year=' + year;
            if (month) url += (year ? '&month=' : 'month=') + month;
            if (date) url += ((year || month) ? '&date=' : 'date=') + date;
            window.location.href = url;
        }

        function resetFilter() {
            window.location.href = 'history';
        }

        function filterByPlanDate(date) {
            window.location.href = 'history?date=' + date;
        }
    </script>
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
            <h2>📜 历史记录</h2>
            <p>查看您的体重变化历史和过往生成的健康计划</p>
        </div>

        <!-- 搜索栏 -->
        <div class="search-bar">
            <div class="search-form">
                <div class="search-group">
                    <label><i class="fas fa-calendar"></i> 年份</label>
                    <select id="year" name="year">
                        <option value="">全部年份</option>
                        <%
                            java.util.Calendar cal = java.util.Calendar.getInstance();
                            int currentYear = cal.get(java.util.Calendar.YEAR);
                            for (int y = currentYear; y >= 2024; y--) {
                        %>
                        <option value="<%= y %>" <%= (searchYear != null && Integer.toString(y).equals(searchYear)) ? "selected" : "" %>><%= y %> 年</option>
                        <% } %>
                    </select>
                </div>
                <div class="search-group">
                    <label><i class="fas fa-calendar-alt"></i> 月份</label>
                    <select id="month" name="month">
                        <option value="">全部月份</option>
                        <% for (int m = 1; m <= 12; m++) { %>
                        <option value="<%= m %>" <%= (searchMonth != null && Integer.toString(m).equals(searchMonth)) ? "selected" : "" %>><%= m %> 月</option>
                        <% } %>
                    </select>
                </div>
                <div class="search-group">
                    <label><i class="fas fa-calendar-day"></i> 具体日期</label>
                    <input type="date" id="date" name="date" value="<%= searchDate != null ? searchDate : "" %>">
                </div>
                <div class="search-group" style="flex: 0 0 auto;">
                    <button class="search-btn" onclick="filterByYear()"><i class="fas fa-search"></i> 查询</button>
                    <button class="reset-btn" onclick="resetFilter()" style="margin-left: 10px;"><i class="fas fa-undo"></i> 重置</button>
                </div>
            </div>
        </div>

        <!-- 体重历史 -->
        <div class="card">
            <h2>📊 体重历史记录</h2>
            <% if (weightRecords != null && !weightRecords.isEmpty()) { %>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>日期</th>
                                <th>体重 (kg)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (WeightRecord record : weightRecords) { %>
                            <tr>
                                <td><%= record.getRecordDate() %></td>
                                <td><%= record.getWeight() %> kg</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <p>暂无体重记录</p>
            <% } %>
        </div>

        <!-- 计划历史 -->
        <div class="card">
            <h2>📋 历史计划记录</h2>

            <% if (filteredPlans != null && !filteredPlans.isEmpty()) { %>
                <div class="filter-info">
                    <span class="result-count">
                        <i class="fas fa-list"></i> 共找到 <%= filteredPlans.size() %> 条计划记录
                    </span>
                    <span>
                        <% if (searchYear != null || searchMonth != null || (searchDate != null && !searchDate.isEmpty())) { %>
                            <i class="fas fa-filter"></i> 当前筛选结果
                        <% } %>
                    </span>
                </div>

                <% for (PlanRecord plan : filteredPlans) {
                    String weekStartStr = plan.getWeekStart().toString();
                    String displayDate = weekStartStr.substring(0, 10);
                    String formattedCreateTime = sdf.format(plan.getCreateTime());
                %>
                    <div class="plan-item">
                        <div class="plan-date">
                            <div class="plan-date-left">
                                <span><i class="fas fa-calendar-week"></i> 计划开始：<%= displayDate %></span>
                                <span class="plan-time"><i class="fas fa-clock"></i> 生成时间：<%= formattedCreateTime %></span>
                            </div>
                            <span class="plan-badge" onclick="filterByPlanDate('<%= displayDate %>')">
                                <i class="fas fa-search"></i> 查看当天
                            </span>
                        </div>
                        <div class="plan-content">
                            <div style="margin-bottom: 15px;">
                                <strong style="color: var(--primary-1);"><i class="fas fa-apple-alt"></i> 🥗 饮食计划：</strong><br>
                                <%= plan.getDietPlan().replace("\n", "<br>") %>
                            </div>
                            <div>
                                <strong style="color: var(--primary-1);"><i class="fas fa-dumbbell"></i> 🏃 运动计划：</strong><br>
                                <%= plan.getExercisePlan().replace("\n", "<br>") %>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-result">
                    <i class="fas fa-calendar-times" style="font-size: 48px; color: var(--text-light); margin-bottom: 15px; display: block;"></i>
                    <p>暂无计划记录</p>
                    <p style="font-size: 13px; margin-top: 10px;">点击"生成计划"开始您的健康之旅</p>
                    <a href="confirm-plan.jsp" class="btn btn-primary" style="margin-top: 15px; display: inline-block;">🌱 生成计划</a>
                </div>
            <% } %>
        </div>

        <a href="dashboard.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> 返回首页
        </a>
    </div>
</body>
</html>