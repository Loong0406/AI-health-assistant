package com.health.assistant.dao;

import com.health.assistant.model.HealthProfile;
import com.health.assistant.util.DBUtil;

import java.sql.*;
import java.math.BigDecimal;

public class HealthProfileDAO {

    // 保存或更新健康档案
    public boolean saveOrUpdate(HealthProfile profile) {
        if (exists(profile.getUserId())) {
            return update(profile);
        } else {
            return insert(profile);
        }
    }

    private boolean insert(HealthProfile profile) {
        String sql = "INSERT INTO health_profile (user_id, age, gender, height, weight, activity_level, diet_preference, health_goal) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, profile.getUserId());
            pstmt.setInt(2, profile.getAge());
            pstmt.setString(3, profile.getGender());
            pstmt.setBigDecimal(4, profile.getHeight());
            pstmt.setBigDecimal(5, profile.getWeight());
            pstmt.setString(6, profile.getActivityLevel());
            pstmt.setString(7, profile.getDietPreference());
            pstmt.setString(8, profile.getHealthGoal());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean update(HealthProfile profile) {
        String sql = "UPDATE health_profile SET age=?, gender=?, height=?, weight=?, activity_level=?, diet_preference=?, health_goal=? WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, profile.getAge());
            pstmt.setString(2, profile.getGender());
            pstmt.setBigDecimal(3, profile.getHeight());
            pstmt.setBigDecimal(4, profile.getWeight());
            pstmt.setString(5, profile.getActivityLevel());
            pstmt.setString(6, profile.getDietPreference());
            pstmt.setString(7, profile.getHealthGoal());
            pstmt.setInt(8, profile.getUserId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 检查是否存在档案
    public boolean exists(int userId) {
        String sql = "SELECT id FROM health_profile WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 根据用户ID获取健康档案
    public HealthProfile findByUserId(int userId) {
        String sql = "SELECT * FROM health_profile WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                HealthProfile profile = new HealthProfile();
                profile.setId(rs.getInt("id"));
                profile.setUserId(rs.getInt("user_id"));
                profile.setAge(rs.getInt("age"));
                profile.setGender(rs.getString("gender"));
                profile.setHeight(rs.getBigDecimal("height"));
                profile.setWeight(rs.getBigDecimal("weight"));
                profile.setActivityLevel(rs.getString("activity_level"));
                profile.setDietPreference(rs.getString("diet_preference"));
                profile.setHealthGoal(rs.getString("health_goal"));
                profile.setUpdateTime(rs.getTimestamp("update_time"));
                return profile;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}