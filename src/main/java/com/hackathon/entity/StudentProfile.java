package com.hackathon.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "student_profiles")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StudentProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    private String profilePic;
    private String college;
    private String course;
    private String branch;

    @Column(length = 2000)
    private String skills;

    @Column(length = 2000)
    private String techStack;

    private Integer experienceYears;

    @Column(length = 2000)
    private String previousHackathons;

    @Column(length = 4000)
    private String projects;

    private String github;
    private String linkedin;
    private String portfolio;
    private String leetcode;
    private String resumeUrl;

    @Column(length = 2000)
    private String bio;

    // "Looking for Team" Toggle & Meta
    @Builder.Default
    private boolean lookingForTeam = false;

    @Column(length = 1000)
    private String lookingHackathons;

    @Column(length = 1000)
    private String lookingSkills;

    private String lookingRole;
    private String lookingLocation;
    private String lookingAvailability;

    @Column(length = 2000)
    private String lookingIntro;

    private LocalDateTime updatedAt;

    @PrePersist
    @PreUpdate
    protected void onSave() {
        updatedAt = LocalDateTime.now();
    }
}
