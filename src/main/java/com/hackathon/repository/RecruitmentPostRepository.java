package com.hackathon.repository;

import com.hackathon.entity.RecruitmentPost;
import com.hackathon.entity.Team;
import com.hackathon.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RecruitmentPostRepository extends JpaRepository<RecruitmentPost, Long> {

    List<RecruitmentPost> findByStatusOrderByCreatedAtDesc(String status);

    List<RecruitmentPost> findByTeamLeadOrderByCreatedAtDesc(User teamLead);

    Optional<RecruitmentPost> findByTeamAndStatus(Team team, String status);

    @Query("SELECT r FROM RecruitmentPost r WHERE r.status = :status " +
           "AND (:hackathonId IS NULL OR r.hackathon.id = :hackathonId) " +
           "AND (:onlinePref IS NULL OR r.onlinePref = :onlinePref) " +
           "AND (:experienceLevel IS NULL OR r.experienceLevel = :experienceLevel) " +
           "ORDER BY r.createdAt DESC")
    List<RecruitmentPost> filterPosts(
            @Param("status") String status,
            @Param("hackathonId") Long hackathonId,
            @Param("onlinePref") Boolean onlinePref,
            @Param("experienceLevel") String experienceLevel
    );
}
