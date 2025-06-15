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
public class Complaint implements SuperEntity {
    private String complaintId;
    private String subject;
    private String description;
    private ComplaintStatus complaintStatus;
    private LocalDateTime submittedAt;
    private String adminRemark;
    private LocalDateTime adminRemarkedAt;
    private int employeeId;
}

