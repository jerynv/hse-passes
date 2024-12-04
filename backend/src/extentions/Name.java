package src.extentions;

public class Name {
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
