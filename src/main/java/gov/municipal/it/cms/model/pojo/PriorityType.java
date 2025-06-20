package gov.municipal.it.cms.model.pojo;

import lombok.Getter;

@Getter
public enum PriorityType {
    LOW("low"),
    MEDIUM("medium"),
    HIGH("high");

    private final String dbValue;

    PriorityType(String dbValue) {
        this.dbValue = dbValue;
    }

    public static PriorityType fromDbValue(String dbValue) {
        for (PriorityType type : PriorityType.values()) {
            if (type.getDbValue().equalsIgnoreCase(dbValue)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown dbValue: " + dbValue);
    }
}
