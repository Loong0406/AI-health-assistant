package com.health.assistant.dao;

import com.health.assistant.model.PlanRecord;
import com.health.assistant.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlanRecordDAO {

    public boolean save(PlanRecord record) {
        String sql = "INSERT INTO plan_record (user_id, week_start, diet_plan, exercise_plan) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, record.getUserId());
            ps.setDate(2, new java.sql.Date(record.getWeekStart().getTime()));
            ps.setString(3, record.getDietPlan());
            ps.setString(4, record.getExercisePlan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<PlanRecord> findByUserId(int userId) {
        List<PlanRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM plan_record WHERE user_id = ? ORDER BY week_start DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PlanRecord record = new PlanRecord();
                record.setId(rs.getInt("id"));
                record.setUserId(rs.getInt("user_id"));
                record.setWeekStart(rs.getDate("week_start"));
                record.setDietPlan(rs.getString("diet_plan"));
                record.setExercisePlan(rs.getString("exercise_plan"));
                record.setCreateTime(rs.getTimestamp("create_time"));
                list.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public PlanRecord getLatest(int userId) {
        String sql = "SELECT * FROM plan_record WHERE user_id = ? ORDER BY week_start DESC LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PlanRecord record = new PlanRecord();
                record.setId(rs.getInt("id"));
                record.setUserId(rs.getInt("user_id"));
                record.setWeekStart(rs.getDate("week_start"));
                record.setDietPlan(rs.getString("diet_plan"));
                record.setExercisePlan(rs.getString("exercise_plan"));
                record.setCreateTime(rs.getTimestamp("create_time"));
                return record;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}