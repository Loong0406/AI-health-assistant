package com.health.assistant.model;

import java.math.BigDecimal;
import java.util.Date;

public class HealthProfile {
    private int id;
    private int userId;
    private int age;
    private String gender;
    private BigDecimal height;
    private BigDecimal weight;
    private String activityLevel;
    private String dietPreference;
    private String healthGoal;
    private Date updateTime;

    // 构造函数
    public HealthProfile() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public BigDecimal getHeight() { return height; }
    public void setHeight(BigDecimal height) { this.height = height; }

    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }

    public String getActivityLevel() { return activityLevel; }
    public void setActivityLevel(String activityLevel) { this.activityLevel = activityLevel; }

    public String getDietPreference() { return dietPreference; }
    public void setDietPreference(String dietPreference) { this.dietPreference = dietPreference; }

    public String getHealthGoal() { return healthGoal; }
    public void setHealthGoal(String healthGoal) { this.healthGoal = healthGoal; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
}