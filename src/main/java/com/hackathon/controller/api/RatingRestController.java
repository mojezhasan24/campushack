package com.hackathon.controller.api;

import com.hackathon.entity.Rating;
import com.hackathon.entity.User;
import com.hackathon.service.RatingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpSession;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/ratings")
@RequiredArgsConstructor
@Tag(name = "Rating & Leaderboard API", description = "Judge scoring and leaderboard endpoints")
public class RatingRestController {

    private final RatingService ratingService;

    @PostMapping
    @Operation(summary = "Rate submission (Judge)", description = "Submit scores for Innovation, Technical, Design, and Presentation")
    public ResponseEntity<?> rateSubmission(@RequestBody RateRequest request, HttpSession session) {
        User judge = (User) session.getAttribute("user");
        Long judgeId = (judge != null) ? judge.getId() : request.getJudgeId();

        if (judgeId == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Judge authentication required."));
        }

        Rating rating = ratingService.rateSubmission(
                request.getSubmissionId(),
                judgeId,
                request.getInnovationScore(),
                request.getTechnicalScore(),
                request.getDesignScore(),
                request.getPresentationScore(),
                request.getFeedback()
        );
        return ResponseEntity.ok(rating);
    }

    @GetMapping("/leaderboard/{hackathonId}")
    @Operation(summary = "Get hackathon leaderboard", description = "Fetch calculated average scores and rankings")
    public ResponseEntity<List<Map<String, Object>>> getLeaderboard(@PathVariable Long hackathonId) {
        return ResponseEntity.ok(ratingService.getLeaderboardForHackathon(hackathonId));
    }

    @Data
    public static class RateRequest {
        private Long submissionId;
        private Long judgeId;
        private Integer innovationScore;
        private Integer technicalScore;
        private Integer designScore;
        private Integer presentationScore;
        private String feedback;
    }
}
