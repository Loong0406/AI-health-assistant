package com.health.assistant.dao;

import com.health.assistant.model.WeightRecord;
import com.health.assistant.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WeightRecordDAO {

    public boolean add(WeightRecord record) {
        String sql = "INSERT INTO weight_record (user_id, weight, record_date) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE weight = VALUES(weight)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, record.getUserId());
            ps.setBigDecimal(2, record.getWeight());
            ps.setDate(3, new java.sql.Date(record.getRecordDate().getTime()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<WeightRecord> findByUserId(int userId) {
        List<WeightRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM weight_record WHERE user_id = ? ORDER BY record_date ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                WeightRecord record = new WeightRecord();
                record.setId(rs.getInt("id"));
                record.setUserId(rs.getInt("user_id"));
                record.setWeight(rs.getBigDecimal("weight"));
                record.setRecordDate(rs.getDate("record_date"));
                record.setCreateTime(rs.getTimestamp("create_time"));
                list.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public WeightRecord getLatest(int userId) {
        String sql = "SELECT * FROM weight_record WHERE user_id = ? ORDER BY record_date DESC LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                WeightRecord record = new WeightRecord();
                record.setId(rs.getInt("id"));
                record.setUserId(rs.getInt("user_id"));
                record.setWeight(rs.getBigDecimal("weight"));
                record.setRecordDate(rs.getDate("record_date"));
                record.setCreateTime(rs.getTimestamp("create_time"));
                return record;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}