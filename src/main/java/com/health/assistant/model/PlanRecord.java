package com.health.assistant.model;

import java.util.Date;

public class PlanRecord {
    private int id;
    private int userId;
    private Date weekStart;
    private String dietPlan;
    private String exercisePlan;
    private Date createTime;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getWeekStart() { return weekStart; }
    public void setWeekStart(Date weekStart) { this.weekStart = weekStart; }

    public String getDietPlan() { return dietPlan; }
    public void setDietPlan(String dietPlan) { this.dietPlan = dietPlan; }

    public String getExercisePlan() { return exercisePlan; }
    public void setExercisePlan(String exercisePlan) { this.exercisePlan = exercisePlan; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}