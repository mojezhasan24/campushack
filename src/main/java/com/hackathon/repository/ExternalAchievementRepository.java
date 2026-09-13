package com.hackathon.repository;

import com.hackathon.entity.AchievementStatus;
import com.hackathon.entity.ExternalAchievement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExternalAchievementRepository extends JpaRepository<ExternalAchievement, Long> {
    List<ExternalAchievement> findByStudentId(Long studentId);
    List<ExternalAchievement> findByStudentIdAndStatus(Long studentId, AchievementStatus status);
    List<ExternalAchievement> findByStatus(AchievementStatus status);
}
