package com.hackathon.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "hackathons")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Hackathon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(length = 2000)
    private String description;

    private String category;

    private LocalDate startDate;

    private LocalDate endDate;

    private LocalDate registrationDeadline;

    private Double prizePool;

    private Integer maxTeamSize;

    @Enumerated(EnumType.STRING)
    private HackathonStatus status;

    private String coverImageUrl;

    @Builder.Default
    private boolean deleted = false;

    public String getFormattedPrizePool() {
        if (prizePool == null) return "$0";
        if (prizePool == Math.floor(prizePool)) {
            return String.format("$%,d", prizePool.longValue());
        }
        return String.format("$%,.2f", prizePool);
    }

    public String getFormattedRegistrationDeadline() {
        if (registrationDeadline == null) return "N/A";
        return registrationDeadline.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }
}
