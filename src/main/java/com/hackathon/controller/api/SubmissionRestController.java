package com.hackathon.controller.api;

import com.hackathon.entity.Submission;
import com.hackathon.service.RatingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/submissions")
@RequiredArgsConstructor
@Tag(name = "Submission API", description = "Project submission endpoints for participants")
public class SubmissionRestController {

    private final RatingService ratingService;

    @PostMapping
    @Operation(summary = "Submit project", description = "Submit or update project links (GitHub/Demo)")
    public ResponseEntity<Submission> submitProject(@RequestBody SubmitProjectRequest request) {
        Submission submission = ratingService.submitProject(
                request.getHackathonId(),
                request.getTeamId(),
                request.getProjectTitle(),
                request.getDescription(),
                request.getGithubUrl(),
                request.getDemoUrl()
        );
        return ResponseEntity.ok(submission);
    }

    @GetMapping("/hackathon/{hackathonId}")
    @Operation(summary = "Get submissions", description = "Retrieve all team project submissions for a hackathon")
    public ResponseEntity<List<Submission>> getSubmissionsForHackathon(@PathVariable Long hackathonId) {
        return ResponseEntity.ok(ratingService.getSubmissionsForHackathon(hackathonId));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get submission details", description = "Fetch single submission by ID")
    public ResponseEntity<Submission> getSubmissionById(@PathVariable Long id) {
        return ResponseEntity.ok(ratingService.getSubmissionById(id));
    }

    @Data
    public static class SubmitProjectRequest {
        private Long hackathonId;
        private Long teamId;
        private String projectTitle;
        private String description;
        private String githubUrl;
        private String demoUrl;
    }
}
