package src.extentions;

import java.util.List;

public class Classroom {
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
