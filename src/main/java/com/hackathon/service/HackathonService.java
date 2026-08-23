package com.hackathon.service;

import com.hackathon.entity.Hackathon;
import com.hackathon.entity.HackathonStatus;
import com.hackathon.entity.Team;
import com.hackathon.entity.User;
import com.hackathon.repository.HackathonRepository;
import com.hackathon.repository.SubmissionRepository;
import com.hackathon.repository.TeamRepository;
import com.hackathon.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class HackathonService {

    private final HackathonRepository hackathonRepository;
    private final UserRepository userRepository;
    private final TeamRepository teamRepository;
    private final SubmissionRepository submissionRepository;

    public List<Hackathon> getAllHackathons() {
        return hackathonRepository.findByDeletedFalse();
    }

    public List<Hackathon> getHackathonsByStatus(HackathonStatus status) {
        return hackathonRepository.findByStatusAndDeletedFalse(status);
    }

    public Hackathon getHackathonById(Long id) {
        Hackathon h = hackathonRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Hackathon not found with ID: " + id));
        if (h.isDeleted()) {
            throw new IllegalArgumentException("Hackathon has been deleted.");
        }
        return h;
    }

    public Hackathon createHackathon(Hackathon hackathon) {
        if (hackathon.getRegistrationDeadline() == null) {
            hackathon.setRegistrationDeadline(hackathon.getStartDate());
        }
        hackathon.setStatus(computeStatus(hackathon.getStartDate(), hackathon.getEndDate(), hackathon.getStatus()));
        hackathon.setDeleted(false);
        return hackathonRepository.save(hackathon);
    }

    public Hackathon updateHackathon(Long id, Hackathon updatedDetails) {
        Hackathon existing = getHackathonById(id);
        existing.setTitle(updatedDetails.getTitle());
        existing.setDescription(updatedDetails.getDescription());
        existing.setCategory(updatedDetails.getCategory());
        existing.setStartDate(updatedDetails.getStartDate());
        existing.setEndDate(updatedDetails.getEndDate());
        existing.setRegistrationDeadline(updatedDetails.getRegistrationDeadline() != null ? updatedDetails.getRegistrationDeadline() : updatedDetails.getStartDate());
        existing.setPrizePool(updatedDetails.getPrizePool());
        existing.setMaxTeamSize(updatedDetails.getMaxTeamSize());
        existing.setStatus(computeStatus(updatedDetails.getStartDate(), updatedDetails.getEndDate(), updatedDetails.getStatus()));
        if (updatedDetails.getCoverImageUrl() != null && !updatedDetails.getCoverImageUrl().isBlank()) {
            existing.setCoverImageUrl(updatedDetails.getCoverImageUrl());
        }
        return hackathonRepository.save(existing);
    }

    public void deleteHackathon(Long id) {
        Hackathon hackathon = getHackathonById(id);
        List<Team> teams = teamRepository.findByHackathon(hackathon);
        if (!teams.isEmpty()) {
            throw new IllegalStateException("Cannot delete hackathon '" + hackathon.getTitle() + "' because " + teams.size() + " teams are currently registered for it.");
        }
        hackathon.setDeleted(true);
        hackathonRepository.save(hackathon);
    }

    public List<Hackathon> searchHackathons(String query) {
        if (query == null || query.isBlank()) {
            return getAllHackathons();
        }
        return hackathonRepository.searchHackathons(query);
    }

    private HackathonStatus computeStatus(LocalDate startDate, LocalDate endDate, HackathonStatus explicitStatus) {
        if (explicitStatus != null) {
            return explicitStatus;
        }
        LocalDate now = LocalDate.now();
        if (startDate != null && now.isBefore(startDate)) {
            return HackathonStatus.UPCOMING;
        } else if (endDate != null && now.isAfter(endDate)) {
            return HackathonStatus.COMPLETED;
        }
        return HackathonStatus.ACTIVE;
    }

    // 100% Database-Driven Analytics Summary
    public Map<String, Object> getAnalyticsSummary() {
        Map<String, Object> summary = new HashMap<>();

        long totalHackathons = hackathonRepository.countByDeletedFalse();
        long totalUsers = userRepository.count();
        long totalTeams = teamRepository.count();
        long totalSubmissions = submissionRepository.count();

        summary.put("totalHackathons", totalHackathons);
        summary.put("totalParticipants", totalUsers);
        summary.put("totalTeams", totalTeams);
        summary.put("totalSubmissions", totalSubmissions);
        summary.put("avgParticipation", totalHackathons > 0 ? totalUsers / totalHackathons : 0);

        // Branch Distribution
        List<Object[]> branchData = userRepository.getBranchDistribution();
        Map<String, Long> branchMap = new LinkedHashMap<>();
        for (Object[] row : branchData) {
            String branchName = (String) row[0];
            Long count = (Long) row[1];
            if (branchName != null && !branchName.isBlank()) {
                branchMap.put(branchName, count);
            }
        }
        summary.put("branchDistribution", branchMap);

        // Recent Activity (5 most recent users & 5 most recent hackathons)
        List<User> recentUsers = userRepository.findTop5ByOrderByIdDesc();
        List<Hackathon> recentHackathons = hackathonRepository.findTop5ByDeletedFalseOrderByIdDesc();

        summary.put("recentUsers", recentUsers);
        summary.put("recentHackathons", recentHackathons);

        return summary;
    }
}

