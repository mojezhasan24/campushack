package com.hackathon.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    private String fullName;

    @Column(unique = true, nullable = false)
    private String email;

    private String rollNumber;
    
    private String branch;
    
    private String yearOfStudy;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    private String otpCode;

    private LocalDateTime otpExpiry;

    @Builder.Default
    private boolean enabled = false;

    @Column(updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "N/A";
        return createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
    }
}
