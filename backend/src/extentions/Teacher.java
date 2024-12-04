package src.extentions;

import java.util.List;

public class Teacher {
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
