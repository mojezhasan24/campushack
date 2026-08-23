package com.hackathon.service;

import com.hackathon.entity.*;
import com.hackathon.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RatingService {

    private final SubmissionRepository submissionRepository;
    private final RatingRepository ratingRepository;
    private final TeamRepository teamRepository;
    private final HackathonRepository hackathonRepository;
    private final UserRepository userRepository;

    public Submission submitProject(Long hackathonId, Long teamId, String projectTitle, String description, String githubUrl, String demoUrl) {
        Hackathon hackathon = hackathonRepository.findById(hackathonId)
                .orElseThrow(() -> new IllegalArgumentException("Hackathon not found."));
        Team team = teamRepository.findById(teamId)
                .orElseThrow(() -> new IllegalArgumentException("Team not found."));

        Optional<Submission> existing = submissionRepository.findByTeam(team);
        Submission submission;
        if (existing.isPresent()) {
            submission = existing.get();
            submission.setProjectTitle(projectTitle);
            submission.setDescription(description);
            submission.setGithubUrl(githubUrl);
            submission.setDemoUrl(demoUrl);
            submission.setSubmittedAt(LocalDateTime.now());
        } else {
            submission = Submission.builder()
                    .hackathon(hackathon)
                    .team(team)
                    .projectTitle(projectTitle)
                    .description(description)
                    .githubUrl(githubUrl)
                    .demoUrl(demoUrl)
                    .submittedAt(LocalDateTime.now())
                    .build();
        }
        return submissionRepository.save(submission);
    }

    public List<Submission> getSubmissionsForHackathon(Long hackathonId) {
        Hackathon hackathon = hackathonRepository.findById(hackathonId)
                .orElseThrow(() -> new IllegalArgumentException("Hackathon not found."));
        return submissionRepository.findByHackathon(hackathon);
    }

    public Submission getSubmissionById(Long id) {
        return submissionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Submission not found with ID: " + id));
    }

    public Rating rateSubmission(Long submissionId, Long judgeUserId, Integer innovation, Integer technical, Integer design, Integer presentation, String feedback) {
        Submission submission = getSubmissionById(submissionId);
        User judge = userRepository.findById(judgeUserId)
                .orElseThrow(() -> new IllegalArgumentException("Judge not found."));

        double total = (innovation + technical + design + presentation) / 4.0;

        Optional<Rating> existingRatingOpt = ratingRepository.findBySubmissionAndJudge(submission, judge);
        Rating rating;
        if (existingRatingOpt.isPresent()) {
            rating = existingRatingOpt.get();
            rating.setInnovationScore(innovation);
            rating.setTechnicalScore(technical);
            rating.setDesignScore(design);
            rating.setPresentationScore(presentation);
            rating.setTotalScore(total);
            rating.setFeedback(feedback);
        } else {
            rating = Rating.builder()
                    .submission(submission)
                    .judge(judge)
                    .innovationScore(innovation)
                    .technicalScore(technical)
                    .designScore(design)
                    .presentationScore(presentation)
                    .totalScore(total)
                    .feedback(feedback)
                    .build();
        }

        return ratingRepository.save(rating);
    }

    public List<Map<String, Object>> getLeaderboardForHackathon(Long hackathonId) {
        List<Submission> submissions = getSubmissionsForHackathon(hackathonId);
        List<Map<String, Object>> leaderboard = new ArrayList<>();

        for (Submission s : submissions) {
            Double avgScore = ratingRepository.getAverageScoreForSubmission(s);
            Map<String, Object> entry = new HashMap<>();
            entry.put("submissionId", s.getId());
            entry.put("projectTitle", s.getProjectTitle());
            entry.put("teamName", s.getTeam().getTeamName());
            entry.put("averageScore", avgScore != null ? Math.round(avgScore * 100.0) / 100.0 : 0.0);
            entry.put("githubUrl", s.getGithubUrl());
            entry.put("demoUrl", s.getDemoUrl());
            leaderboard.add(entry);
        }

        leaderboard.sort((a, b) -> Double.compare((Double) b.get("averageScore"), (Double) a.get("averageScore")));
        return leaderboard;
    }
}
