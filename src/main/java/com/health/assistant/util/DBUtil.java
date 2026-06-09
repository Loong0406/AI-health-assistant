package com.health.assistant.util;

import java.sql.*;

public class DBUtil {
    // MySQL 配置（请根据您的实际配置修改）
    private static final String URL = "jdbc:mysql://localhost:3306/health_assistant?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf-8";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "20060406";  // 改成您的 MySQL 密码
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
}