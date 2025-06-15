package gov.municipal.it.cms.model.pojo;

import lombok.Getter;

@Getter
public enum ComplaintStatus {
    PENDING("pending"),
    IN_PROGRESS("in_progress"),
    RESOLVED("resolved"),
    Closed("closed");

    private final String dbValue;

    ComplaintStatus(String dbValue) {
        this.dbValue = dbValue;
    }

}
