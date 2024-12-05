package src.extensions;

import java.util.Date;

public class Pass {
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
