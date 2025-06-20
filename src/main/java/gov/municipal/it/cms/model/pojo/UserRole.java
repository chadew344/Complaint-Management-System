package gov.municipal.it.cms.model.pojo;

import lombok.Getter;

@Getter
public enum UserRole {
    EMPLOYEE("employee"),
    ADMIN("admin");

    private final String dbValue;

    UserRole(String dbValue) {
        this.dbValue = dbValue;
    }

    public static UserRole fromDbValue(String dbValue) {
        for (UserRole role : UserRole.values()) {
            if (role.getDbValue().equalsIgnoreCase(dbValue)) {
                return role;
            }
        }
        throw new IllegalArgumentException("Unknown dbValue: " + dbValue);
    }
}
