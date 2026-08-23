package com.hackathon.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ratings")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Rating {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "submission_id", nullable = false)
    private Submission submission;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "judge_id", nullable = false)
    private User judge;

    private Integer innovationScore;
    private Integer technicalScore;
    private Integer designScore;
    private Integer presentationScore;
    
    private Double totalScore;

    @Column(length = 1000)
    private String feedback;
}
