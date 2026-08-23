package com.hackathon.controller.api;

import com.hackathon.entity.Team;
import com.hackathon.entity.User;
import com.hackathon.service.RegistrationService;
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
@RequestMapping("/api/teams")
@RequiredArgsConstructor
@Tag(name = "Team Management API", description = "Team creation, joining, and listing endpoints")
public class TeamRestController {

    private final RegistrationService registrationService;

    @PostMapping("/create")
    @Operation(summary = "Create team", description = "Create a team for a hackathon and receive an invite code")
    public ResponseEntity<?> createTeam(@RequestBody CreateTeamRequest request, HttpSession session) {
        User user = (User) session.getAttribute("user");
        Long leaderId = (user != null) ? user.getId() : request.getLeaderId();
        
        if (leaderId == null) {
            return ResponseEntity.status(401).body(Map.of("error", "User must be logged in to create a team."));
        }

        Team team = registrationService.createTeam(request.getHackathonId(), leaderId, request.getTeamName());
        return ResponseEntity.ok(team);
    }

    @PostMapping("/join")
    @Operation(summary = "Join team", description = "Join a team using an invite code")
    public ResponseEntity<?> joinTeam(@RequestBody JoinTeamRequest request, HttpSession session) {
        User user = (User) session.getAttribute("user");
        Long userId = (user != null) ? user.getId() : request.getUserId();

        if (userId == null) {
            return ResponseEntity.status(401).body(Map.of("error", "User must be logged in to join a team."));
        }

        Team team = registrationService.joinTeamByInviteCode(request.getInviteCode(), userId);
        return ResponseEntity.ok(team);
    }

    @GetMapping("/hackathon/{hackathonId}")
    @Operation(summary = "Get teams for hackathon", description = "List all registered teams for a hackathon")
    public ResponseEntity<List<Team>> getTeamsForHackathon(@PathVariable Long hackathonId) {
        return ResponseEntity.ok(registrationService.getTeamsForHackathon(hackathonId));
    }

    @Data
    public static class CreateTeamRequest {
        private Long hackathonId;
        private Long leaderId;
        private String teamName;
    }

    @Data
    public static class JoinTeamRequest {
        private String inviteCode;
        private Long userId;
    }
}
