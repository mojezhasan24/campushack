package com.hackathon.controller.api;

import com.hackathon.entity.Hackathon;
import com.hackathon.entity.HackathonStatus;
import com.hackathon.entity.User;
import com.hackathon.service.HackathonService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hackathons")
@RequiredArgsConstructor
@Tag(name = "Hackathon API", description = "CRUD and search endpoints for Hackathons")
public class HackathonRestController {

    private final HackathonService hackathonService;

    @GetMapping
    @Operation(summary = "Get all hackathons")
    public ResponseEntity<List<Hackathon>> getAllHackathons(@RequestParam(required = false) String search) {
        if (search != null && !search.isBlank()) {
            return ResponseEntity.ok(hackathonService.searchHackathons(search));
        }
        return ResponseEntity.ok(hackathonService.getAllHackathons());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get hackathon details")
    public ResponseEntity<Hackathon> getById(@PathVariable Long id) {
        return ResponseEntity.ok(hackathonService.getHackathonById(id));
    }

    @PostMapping("/{id}/register")
    @Operation(summary = "Register for hackathon (student)")
    public ResponseEntity<?> registerForHackathon(@PathVariable Long id, @AuthenticationPrincipal User user) {
        // Implement logic to attach student to hackathon or team creation
        return ResponseEntity.ok(Map.of("message", "Registered for hackathon " + id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Create hackathon (Admin)")
    public ResponseEntity<Hackathon> create(@RequestBody Hackathon hackathon) {
        return ResponseEntity.ok(hackathonService.createHackathon(hackathon));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update hackathon (Admin)")
    public ResponseEntity<Hackathon> update(@PathVariable Long id, @RequestBody Hackathon hackathon) {
        return ResponseEntity.ok(hackathonService.updateHackathon(id, hackathon));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Delete hackathon (Admin)")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        hackathonService.deleteHackathon(id);
        return ResponseEntity.ok(Map.of("message", "Hackathon deleted successfully"));
    }
}
