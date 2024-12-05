package src.extensions;

import java.util.List;

public class Admin {
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
