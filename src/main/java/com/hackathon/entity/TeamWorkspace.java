package com.hackathon.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "team_workspaces")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TeamWorkspace {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "team_id", nullable = false, unique = true)
    private Team team;

    @Column(length = 2000)
    private String description;

    @Column(length = 4000)
    private String projectInfo;

    private LocalDate submissionDeadline;

    @Column(length = 2000)
    private String sharedLinks; // GitHub, WhatsApp, Figma

    @Column(length = 4000)
    private String taskBoard;

    private LocalDateTime updatedAt;

    @PrePersist
    @PreUpdate
    protected void onSave() {
        updatedAt = LocalDateTime.now();
    }
}
