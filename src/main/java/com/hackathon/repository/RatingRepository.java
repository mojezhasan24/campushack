package com.hackathon.repository;

import com.hackathon.entity.Rating;
import com.hackathon.entity.Submission;
import com.hackathon.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface RatingRepository extends JpaRepository<Rating, Long> {
    List<Rating> findBySubmission(Submission submission);
    Optional<Rating> findBySubmissionAndJudge(Submission submission, User judge);

    @Query("SELECT AVG(r.totalScore) FROM Rating r WHERE r.submission = :submission")
    Double getAverageScoreForSubmission(@Param("submission") Submission submission);
}
