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
    private String name;
    private String email;
    private String username;
    private String password;
    private UserRole role;
    private LocalDateTime createdAt;
}
