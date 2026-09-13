package com.hackathon.controller.api;

import com.hackathon.entity.AchievementStatus;
import com.hackathon.entity.ExternalAchievement;
import com.hackathon.entity.User;
import com.hackathon.service.ExternalAchievementService;
import com.hackathon.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/achievements")
public class ExternalAchievementRestController {

    @Autowired
    private ExternalAchievementService achievementService;

    @Autowired
    private UserService userService;

    @Autowired
    private com.hackathon.service.FileStorageService fileStorageService;

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final java.util.List<String> ALLOWED_MIME_TYPES = java.util.Arrays.asList(
            "image/jpeg", "image/png", "application/pdf"
    );

    @PostMapping("/submit")
    public ResponseEntity<?> submitAchievement(
            @RequestParam("hackathonName") String hackathonName,
            @RequestParam("organizer") String organizer,
            @RequestParam("date") String date,
            @RequestParam("projectTitle") String projectTitle,
            @RequestParam("projectRepoLink") String projectRepoLink,
            @RequestParam("demoLink") String demoLink,
            @RequestParam(value = "certificate", required = false) MultipartFile certificate,
            HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "Unauthorized"));
        }

        User student = null;
        try {
            student = userService.getUserById(userId);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "User not found"));
        }

        ExternalAchievement achievement = new ExternalAchievement();
        achievement.setStudent(student);
        achievement.setHackathonName(hackathonName);
        achievement.setOrganizer(organizer);
        achievement.setDate(date);
        achievement.setProjectTitle(projectTitle);
        achievement.setProjectRepoLink(projectRepoLink);
        achievement.setDemoLink(demoLink);

        if (certificate != null && !certificate.isEmpty()) {
            // 1. Validate File Size
            if (certificate.getSize() > MAX_FILE_SIZE) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "File too large (max 5MB)"));
            }

            // 2. Validate MIME Type
            String mimeType = certificate.getContentType();
            if (mimeType == null || !ALLOWED_MIME_TYPES.contains(mimeType)) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Invalid file type. Only JPG, PNG, and PDF allowed."));
            }

            try {
                // Upload file
                String publicUrl = fileStorageService.uploadFile(certificate, "certificates");
                achievement.setCertificatePath(publicUrl);
            } catch (IOException e) {
                e.printStackTrace();
                return ResponseEntity.status(500).body(Map.of("success", false, "message", "Failed to upload certificate"));
            }
        }

        achievementService.saveAchievement(achievement);

        return ResponseEntity.ok(Map.of("success", true, "message", "Achievement submitted successfully"));
    }

    @PostMapping("/{id}/approve")
    public ResponseEntity<?> approveAchievement(@PathVariable Long id, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return ResponseEntity.status(403).body(Map.of("success", false, "message", "Forbidden"));
        }

        ExternalAchievement updated = achievementService.updateAchievementStatus(id, AchievementStatus.APPROVED);
        if (updated != null) {
            return ResponseEntity.ok(Map.of("success", true, "message", "Achievement approved"));
        }
        return ResponseEntity.status(404).body(Map.of("success", false, "message", "Achievement not found"));
    }

    @PostMapping("/{id}/reject")
    public ResponseEntity<?> rejectAchievement(@PathVariable Long id, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return ResponseEntity.status(403).body(Map.of("success", false, "message", "Forbidden"));
        }

        ExternalAchievement updated = achievementService.updateAchievementStatus(id, AchievementStatus.REJECTED);
        if (updated != null) {
            return ResponseEntity.ok(Map.of("success", true, "message", "Achievement rejected"));
        }
        return ResponseEntity.status(404).body(Map.of("success", false, "message", "Achievement not found"));
    }
}
