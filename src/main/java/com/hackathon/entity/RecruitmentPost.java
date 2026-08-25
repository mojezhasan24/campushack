package com.hackathon.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "recruitment_posts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RecruitmentPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hackathon_id", nullable = false)
    private Hackathon hackathon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "team_id", nullable = false)
    private Team team;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "team_lead_id", nullable = false)
    private User teamLead;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private Integer currentSize;

    @Column(nullable = false)
    private Integer maxSize;

    @Column(length = 2000)
    private String requiredSkills;

    @Column(length = 2000)
    private String preferredSkills;

    @Column(length = 2000)
    private String requiredRoles;

    private String experienceLevel;

    private String locationPref;

    @Builder.Default
    private boolean onlinePref = true;

    @Column(length = 4000)
    private String description;

    @Column(length = 4000)
    private String projectDescription;

    private LocalDate applicationDeadline;

    @Column(length = 2000)
    private String additionalRequirements;

    @Builder.Default
    @Column(nullable = false)
    private String status = "OPEN"; // OPEN, CLOSED, EXPIRED

    @Column(updatable = false)
    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
