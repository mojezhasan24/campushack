package com.hackathon.service;

import com.hackathon.entity.Hackathon;
import com.hackathon.entity.Team;
import com.hackathon.entity.User;
import com.hackathon.repository.HackathonRepository;
import com.hackathon.repository.TeamRepository;
import com.hackathon.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RegistrationService {

    private final TeamRepository teamRepository;
    private final HackathonRepository hackathonRepository;
    private final UserRepository userRepository;

    public Team createTeam(Long hackathonId, Long leaderUserId, String teamName) {
        Hackathon hackathon = hackathonRepository.findById(hackathonId)
                .orElseThrow(() -> new IllegalArgumentException("Hackathon not found."));
        User leader = userRepository.findById(leaderUserId)
                .orElseThrow(() -> new IllegalArgumentException("User not found."));

        String inviteCode = UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        Team team = Team.builder()
                .teamName(teamName)
                .hackathon(hackathon)
                .leader(leader)
                .inviteCode(inviteCode)
                .build();
        team.getMembers().add(leader);

        return teamRepository.save(team);
    }

    public Team joinTeamByInviteCode(String inviteCode, Long userId) {
        Team team = teamRepository.findByInviteCode(inviteCode)
                .orElseThrow(() -> new IllegalArgumentException("Invalid invite code."));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found."));

        if (team.getMembers().size() >= team.getHackathon().getMaxTeamSize()) {
            throw new IllegalStateException("Team is already at maximum capacity.");
        }

        team.getMembers().add(user);
        return teamRepository.save(team);
    }

    public List<Team> getTeamsForHackathon(Long hackathonId) {
        Hackathon hackathon = hackathonRepository.findById(hackathonId)
                .orElseThrow(() -> new IllegalArgumentException("Hackathon not found."));
        return teamRepository.findByHackathon(hackathon);
    }

    public Team getTeamById(Long teamId) {
        return teamRepository.findById(teamId)
                .orElseThrow(() -> new IllegalArgumentException("Team not found with id: " + teamId));
    }
}
