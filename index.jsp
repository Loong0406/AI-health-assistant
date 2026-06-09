<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能健康助手 - 个性化饮食与运动规划</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        .hero-content {
            max-width: 800px;
            padding: 40px;
        }
        .hero h1 {
            font-size: 56px;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary-1) 0%, var(--primary-2) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 20px;
        }
        .hero p {
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 40px;
        }
        .btn-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-large {
            padding: 14px 40px;
            font-size: 16px;
        }
        .features-hero {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 80px;
        }
        .feature-hero-item {
            text-align: center;
            padding: 20px;
        }
        .feature-hero-item i {
            font-size: 48px;
            background: linear-gradient(135deg, var(--primary-1) 0%, var(--primary-2) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
        }
        .feature-hero-item h3 {
            color: var(--text-primary);
            margin-bottom: 10px;
        }
        .feature-hero-item p {
            font-size: 14px;
            margin-bottom: 0;
        }
        @media (max-width: 768px) {
            .hero h1 { font-size: 36px; }
            .hero p { font-size: 16px; }
        }
    </style>
</head>
<body>
    <div class="hero">
        <div class="hero-content">
            <h1>🌿 智能健康助手</h1>
            <p>AI 驱动的个性化饮食与运动规划专家，为您量身定制健康方案</p>
            <div class="btn-group">
                <a href="login.jsp" class="btn btn-primary btn-large">登录</a>
                <a href="register.jsp" class="btn btn-outline btn-large">注册</a>
            </div>
            <div class="features-hero">
                <div class="feature-hero-item">
                    <i class="fas fa-chart-line"></i>
                    <h3>个性化分析</h3>
                    <p>基于您的身体数据，量身定制方案</p>
                </div>
                <div class="feature-hero-item">
                    <i class="fas fa-robot"></i>
                    <h3>AI 智能推荐</h3>
                    <p>大语言模型生成专属饮食运动计划</p>
                </div>
                <div class="feature-hero-item">
                    <i class="fas fa-weight-scale"></i>
                    <h3>体重追踪</h3>
                    <p>记录变化趋势，动态调整建议</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>