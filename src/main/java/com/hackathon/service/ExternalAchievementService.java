package com.hackathon.service;

import com.hackathon.entity.AchievementStatus;
import com.hackathon.entity.ExternalAchievement;
import com.hackathon.repository.ExternalAchievementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ExternalAchievementService {

    @Autowired
    private ExternalAchievementRepository achievementRepository;

    public ExternalAchievement saveAchievement(ExternalAchievement achievement) {
        return achievementRepository.save(achievement);
    }

    public List<ExternalAchievement> getAchievementsByStudentId(Long studentId) {
        return achievementRepository.findByStudentId(studentId);
    }

    public List<ExternalAchievement> getAchievementsByStudentIdAndStatus(Long studentId, AchievementStatus status) {
        return achievementRepository.findByStudentIdAndStatus(studentId, status);
    }

    public List<ExternalAchievement> getPendingAchievements() {
        return achievementRepository.findByStatus(AchievementStatus.PENDING);
    }

    public Optional<ExternalAchievement> getAchievementById(Long id) {
        return achievementRepository.findById(id);
    }

    public ExternalAchievement updateAchievementStatus(Long id, AchievementStatus status) {
        return achievementRepository.findById(id).map(achievement -> {
            achievement.setStatus(status);
            return achievementRepository.save(achievement);
        }).orElse(null);
    }
}
