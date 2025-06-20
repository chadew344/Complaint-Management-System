package gov.municipal.it.cms.model.pojo;

import lombok.Getter;

@Getter
public enum ComplaintStatus {
    PENDING("pending"),
    IN_PROGRESS("in_progress"),
    RESOLVED("resolved"),
    CLOSED("closed");

    private final String dbValue;

    ComplaintStatus(String dbValue) {
        this.dbValue = dbValue;
    }

    public static ComplaintStatus fromDbValue(String dbValue) {
        for (ComplaintStatus status : ComplaintStatus.values()) {
            if (status.getDbValue().equalsIgnoreCase(dbValue)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown dbValue: " + dbValue);
    }

}
