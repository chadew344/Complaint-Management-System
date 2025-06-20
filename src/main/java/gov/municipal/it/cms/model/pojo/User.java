package gov.municipal.it.cms.model.pojo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class User implements SuperEntity {
    private Integer id;
    private String name;
    private String email;
    private String username;
    private String password;
    private UserRole role;
    private LocalDateTime createdAt;

    public User(String name, String email, String username, String password, UserRole role, LocalDateTime createdAt) {
        this.name = name;
        this.email = email;
        this.username = username;
        this.password = password;
        this.role = role;
        this.createdAt = createdAt;
    }
}
