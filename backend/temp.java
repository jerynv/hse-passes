// Template.java

import java.util.*;

public class Template {

    // Name Object
    public static class Name {
        private String first;
        private String last;
        private String preferred; // Optional
        private String pronouns; // Optional

        // Constructor
        public Name(String first, String last, String preferred, String pronouns) {
            this.first = first;
            this.last = last;
            this.preferred = preferred;
            this.pronouns = pronouns;
        }

        // Getters and Setters
        public String getFirst() {
            return first;
        }

        public void setFirst(String first) {
            this.first = first;
        }

        public String getLast() {
            return last;
        }

        public void setLast(String last) {
            this.last = last;
        }

        public String getPreferred() {
            return preferred;
        }

        public void setPreferred(String preferred) {
            this.preferred = preferred;
        }

        public String getPronouns() {
            return pronouns;
        }

        public void setPronouns(String pronouns) {
            this.pronouns = pronouns;
        }
    }

    // Classroom Object
    public static class Classroom {
        private String room;
        private String name;
        private List<Teacher> teachers;

        // Constructor
        public Classroom(String room, String name, List<Teacher> teachers) {
            this.room = room;
            this.name = name;
            this.teachers = teachers;
        }

        // Getters and Setters
        public String getRoom() {
            return room;
        }

        public void setRoom(String room) {
            this.room = room;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public List<Teacher> getTeachers() {
            return teachers;
        }

        public void setTeachers(List<Teacher> teachers) {
            this.teachers = teachers;
        }
    }

    // Pass Object
    public static class Pass {
        private String id;
        private Object issuedBy; // Can be Teacher or Admin
        private Student issuedTo;
        private String purpose;
        private Date validFrom;
        private Date validUntil;
        private String status;

        // Constructor
        public Pass(String id, Object issuedBy, Student issuedTo, String purpose, Date validFrom, Date validUntil, String status) {
            this.id = id;
            this.issuedBy = issuedBy;
            this.issuedTo = issuedTo;
            this.purpose = purpose;
            this.validFrom = validFrom;
            this.validUntil = validUntil;
            this.status = status;
        }

        // Getters and Setters
        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public Object getIssuedBy() {
            return issuedBy;
        }

        public void setIssuedBy(Object issuedBy) {
            this.issuedBy = issuedBy;
        }

        public Student getIssuedTo() {
            return issuedTo;
        }

        public void setIssuedTo(Student issuedTo) {
            this.issuedTo = issuedTo;
        }

        public String getPurpose() {
            return purpose;
        }

        public void setPurpose(String purpose) {
            this.purpose = purpose;
        }

        public Date getValidFrom() {
            return validFrom;
        }

        public void setValidFrom(Date validFrom) {
            this.validFrom = validFrom;
        }

        public Date getValidUntil() {
            return validUntil;
        }

        public void setValidUntil(Date validUntil) {
            this.validUntil = validUntil;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }
    }

    // Student Object
    public static class Student {
        private String uuid;
        private String grade;
        private Pass activePass;
        private Map<Integer, List<Classroom>> schedule; // Period-to-Classrooms Map
        private Name name;
        private List<String> permissions;

        // Constructor
        public Student(String uuid, String grade, Pass activePass, Map<Integer, List<Classroom>> schedule, Name name, List<String> permissions) {
            this.uuid = uuid;
            this.grade = grade;
            this.activePass = activePass;
            this.schedule = schedule;
            this.name = name;
            this.permissions = permissions;
        }

        // Getters and Setters
        public String getUuid() {
            return uuid;
        }

        public void setUuid(String uuid) {
            this.uuid = uuid;
        }

        public String getGrade() {
            return grade;
        }

        public void setGrade(String grade) {
            this.grade = grade;
        }

        public Pass getActivePass() {
            return activePass;
        }

        public void setActivePass(Pass activePass) {
            this.activePass = activePass;
        }

        public Map<Integer, List<Classroom>> getSchedule() {
            return schedule;
        }

        public void setSchedule(Map<Integer, List<Classroom>> schedule) {
            this.schedule = schedule;
        }

        public Name getName() {
            return name;
        }

        public void setName(Name name) {
            this.name = name;
        }

        public List<String> getPermissions() {
            return permissions;
        }

        public void setPermissions(List<String> permissions) {
            this.permissions = permissions;
        }
    }

    // Teacher Object
    public static class Teacher {
        private String uuid;
        private Name name;
        private String room;
        private List<String> subjects;
        private List<String> permissions;
        private List<Classroom> assignedClasses;
        private List<Pass> activePasses;

        // Constructor
        public Teacher(String uuid, Name name, String room, List<String> subjects, List<String> permissions, List<Classroom> assignedClasses, List<Pass> activePasses) {
            this.uuid = uuid;
            this.name = name;
            this.room = room;
            this.subjects = subjects;
            this.permissions = permissions;
            this.assignedClasses = assignedClasses;
            this.activePasses = activePasses;
        }

        // Getters and Setters

        public String getUuid() {
            return uuid;
        }

        public void setUuid(String uuid) {
            this.uuid = uuid;
        }

        public Name getName() {
            return name;
        }

        public void setName(Name name) {
            this.name = name;
        }

        public String getRoom() {
            return room;
        }

        public void setRoom(String room) {
            this.room = room;
        }

        public List<String> getSubjects() {
            return subjects;
        }

        public void setSubjects(List<String> subjects) {
            this.subjects = subjects;
        }

        public List<String> getPermissions() {
            return permissions;
        }

        public void setPermissions(List<String> permissions) {
            this.permissions = permissions;
        }

        public List<Classroom> getAssignedClasses() {
            return assignedClasses;
        }

        public void setAssignedClasses(List<Classroom> assignedClasses) {
            this.assignedClasses = assignedClasses;
        }

        public List<Pass> getActivePasses() {
            return activePasses;
        }

        public void setActivePasses(List<Pass> activePass
        ) {
            this.activePasses = activePasses;
        }
    }

    // Admin Object
    public static class Admin {
        private String uuid;
        private Name name;
        private String department;
        private String room;
        private List<String> permissions;
        private List<Teacher> managedTeachers;
        private List<Pass> activePasses;
        private List<Student> managedStudents;

        // Constructor
        public Admin(String uuid, Name name, String department, String room, List<String> permissions, List<Teacher> managedTeachers, List<Pass> activePasses, List<Student> managedStudents) {
            this.uuid = uuid;
            this.name = name;
            this.department = department;
            this.room = room;
            this.permissions = permissions;
            this.managedTeachers = managedTeachers;
            this.activePasses = activePasses;
            this.managedStudents = managedStudents;
        }

        
        // Getters and Setters

        public String getUuid() {
            return uuid;
        }

        public void setUuid(String uuid) {
            this.uuid = uuid;
        }

        public Name getName() {
            return name;
        }

        public void setName(Name name) {
            this.name = name;
        }

        public String getDepartment() {
            return department;
        }

        public void setDepartment(String department) {
            this.department = department;
        }

        public String getRoom() {
            return room;
        }

        public void setRoom(String room) {
            this.room = room;
        }

        public List<String> getPermissions() {
            return permissions;
        }

        public void setPermissions(List<String> permissions) {
            this.permissions = permissions;
        }

        public List<Teacher> getManagedTeachers() {
            return managedTeachers;
        }

        public void setManagedTeachers(List<Teacher> managedTeachers) {
            this.managedTeachers = managedTeachers;
        }

        public List<Pass> getActivePasses() {
            return activePasses;
        }

        public void setActivePasses(List<Pass> activePass
        ) {
            this.activePasses = activePasses;
        }

        public List<Student> getManagedStudents() {
            return managedStudents;
        }

        public void setManagedStudents(List<Student> managedStudents) {
            this.managedStudents = managedStudents;
        }
    }
}