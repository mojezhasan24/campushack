package com.hackathon.controller.api;

import com.hackathon.entity.AchievementStatus;
import com.hackathon.entity.ExternalAchievement;
import com.hackathon.entity.User;
import com.hackathon.service.ExternalAchievementService;
import com.hackathon.service.FileStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
public class ExternalAchievementRestController {

    @Autowired
    private ExternalAchievementService achievementService;

    @Autowired
    private FileStorageService fileStorageService;

    @PostMapping(value = "/api/achievements/external", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> submitAchievement(
            @RequestParam("hackathonName") String hackathonName,
            @RequestParam("organizer") String organizer,
            @RequestParam("date") String date,
            @RequestParam("projectTitle") String projectTitle,
            @RequestParam("projectRepoLink") String projectRepoLink,
            @RequestParam("demoLink") String demoLink,
            @RequestParam(value = "certificate", required = false) MultipartFile certificate,
            @AuthenticationPrincipal User student) {

        ExternalAchievement achievement = new ExternalAchievement();
        achievement.setStudent(student);
        achievement.setHackathonName(hackathonName);
        achievement.setOrganizer(organizer);
        achievement.setDate(date);
        achievement.setProjectTitle(projectTitle);
        achievement.setProjectRepoLink(projectRepoLink);
        achievement.setDemoLink(demoLink);

        if (certificate != null && !certificate.isEmpty()) {
            try {
                String publicUrl = fileStorageService.uploadFile(certificate, "certificates");
                achievement.setCertificatePath(publicUrl);
            } catch (IOException | IllegalArgumentException e) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
            }
        }

        achievementService.saveAchievement(achievement);
        return ResponseEntity.ok(Map.of("success", true, "message", "Achievement submitted successfully", "achievement", achievement));
    }

    @GetMapping("/api/achievements/my")
    public ResponseEntity<List<ExternalAchievement>> getMyAchievements(@AuthenticationPrincipal User student) {
        return ResponseEntity.ok(achievementService.getAchievementsByStudentId(student.getId()));
    }

    @GetMapping("/api/admin/achievements/pending")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<ExternalAchievement>> getPendingAchievements() {
        return ResponseEntity.ok(achievementService.getPendingAchievements());
    }

    @PostMapping("/api/admin/achievements/{id}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> approveAchievement(@PathVariable Long id) {
        ExternalAchievement updated = achievementService.updateAchievementStatus(id, AchievementStatus.APPROVED);
        if (updated != null) {
            return ResponseEntity.ok(Map.of("success", true, "message", "Achievement approved"));
        }
        return ResponseEntity.status(404).body(Map.of("success", false, "message", "Achievement not found"));
    }

    @PostMapping("/api/admin/achievements/{id}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> rejectAchievement(@PathVariable Long id) {
        ExternalAchievement updated = achievementService.updateAchievementStatus(id, AchievementStatus.REJECTED);
        if (updated != null) {
            return ResponseEntity.ok(Map.of("success", true, "message", "Achievement rejected"));
        }
        return ResponseEntity.status(404).body(Map.of("success", false, "message", "Achievement not found"));
    }
}
