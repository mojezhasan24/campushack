package com.hackathon.controller.api;

import com.hackathon.entity.Invitation;
import com.hackathon.entity.RecruitmentPost;
import com.hackathon.entity.User;
import com.hackathon.service.NotificationService;
import com.hackathon.service.RecruitmentService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/recruitment")
@RequiredArgsConstructor
public class RecruitmentRestController {

    private final RecruitmentService recruitmentService;
    private final NotificationService notificationService;

    @PostMapping("/invite")
    public ResponseEntity<?> sendInvite(
            @RequestParam Long postId,
            @RequestParam Long invitedUserId,
            @RequestParam(required = false, defaultValue = "Would love to have you join our hackathon squad!") String message,
            HttpSession session
    ) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            Invitation invitation = recruitmentService.sendInvitation(postId, loggedInUser.getId(), invitedUserId, message);
            return ResponseEntity.ok(Map.of("message", "Invitation sent successfully!", "invitationId", invitation.getId()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/invite/{invitationId}/respond")
    public ResponseEntity<?> respondInvite(
            @PathVariable Long invitationId,
            @RequestParam boolean accept,
            HttpSession session
    ) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            recruitmentService.respondInvitation(invitationId, loggedInUser.getId(), accept);
            return ResponseEntity.ok(Map.of("message", accept ? "Invitation accepted!" : "Invitation declined."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/posts/{postId}/close")
    public ResponseEntity<?> closePost(@PathVariable Long postId, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }

        try {
            recruitmentService.closePost(postId, loggedInUser.getId());
            return ResponseEntity.ok(Map.of("message", "Recruitment post closed successfully."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
