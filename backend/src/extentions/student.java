package com.example.student.model;

import java.util.List;
import java.util.Map;

public class Student {
    private String uuid;
    private String grade;
    private Object activePass; // Placeholder for Pass object (or null)
    private Map<Integer, List<Classroom>> schedule;
    private Name name;
    private List<String> permissions;

    // Constructor
    public Student(String uuid, String grade, Object activePass, Map<Integer, List<Classroom>> schedule, Name name, List<String> permissions) {
        this.uuid = uuid;
        this.grade = grade;
        this.activePass = activePass;
        this.schedule = schedule;
        this.name = name;
        this.permissions = permissions;
    }

    // Getters and Setters (can be generated in your IDE)
    public String getUuid() { return uuid; }
    public void setUuid(String uuid) { this.uuid = uuid; }
    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
    public Object getActivePass() { return activePass; }
    public void setActivePass(Object activePass) { this.activePass = activePass; }
    public Map<Integer, List<Classroom>> getSchedule() { return schedule; }
    public void setSchedule(Map<Integer, List<Classroom>> schedule) { this.schedule = schedule; }
    public Name getName() { return name; }
    public void setName(Name name) { this.name = name; }
    public List<String> getPermissions() { return permissions; }
    public void setPermissions(List<String> permissions) { this.permissions = permissions; }
}
