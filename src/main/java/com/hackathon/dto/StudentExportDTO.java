package com.hackathon.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentExportDTO {
    private String username;
    private String fullName;
    private String email;
    private String branch;
    private String yearOfStudy;
    private String hackathonTitle;
    private String teamName;
    private LocalDateTime registrationDate;
}
