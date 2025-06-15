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

}
