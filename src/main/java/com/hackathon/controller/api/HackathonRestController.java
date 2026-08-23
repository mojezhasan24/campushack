package com.hackathon.controller.api;

import com.hackathon.entity.Hackathon;
import com.hackathon.entity.HackathonStatus;
import com.hackathon.service.HackathonService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
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
    @Operation(summary = "Get all hackathons", description = "Retrieve list of all hackathons or search by query")
    public ResponseEntity<List<Hackathon>> getAllHackathons(@RequestParam(required = false) String search) {
        if (search != null && !search.isBlank()) {
            return ResponseEntity.ok(hackathonService.searchHackathons(search));
        }
        return ResponseEntity.ok(hackathonService.getAllHackathons());
    }

    @GetMapping("/status/{status}")
    @Operation(summary = "Get hackathons by status", description = "Filter by status UPCOMING, ACTIVE, or COMPLETED")
    public ResponseEntity<List<Hackathon>> getByStatus(@PathVariable HackathonStatus status) {
        return ResponseEntity.ok(hackathonService.getHackathonsByStatus(status));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get hackathon details", description = "Fetch hackathon by ID")
    public ResponseEntity<Hackathon> getById(@PathVariable Long id) {
        return ResponseEntity.ok(hackathonService.getHackathonById(id));
    }

    @PostMapping
    @Operation(summary = "Create hackathon (Admin)", description = "Add a new hackathon")
    public ResponseEntity<Hackathon> create(@RequestBody Hackathon hackathon) {
        return ResponseEntity.ok(hackathonService.createHackathon(hackathon));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update hackathon (Admin)", description = "Modify an existing hackathon")
    public ResponseEntity<Hackathon> update(@PathVariable Long id, @RequestBody Hackathon hackathon) {
        return ResponseEntity.ok(hackathonService.updateHackathon(id, hackathon));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete hackathon (Admin)", description = "Remove a hackathon by ID")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        hackathonService.deleteHackathon(id);
        return ResponseEntity.ok(Map.of("message", "Hackathon deleted successfully"));
    }

    @GetMapping("/analytics/summary")
    @Operation(summary = "Get analytics summary", description = "Fetch aggregate statistics for admin dashboard")
    public ResponseEntity<Map<String, Object>> getAnalyticsSummary() {
        return ResponseEntity.ok(hackathonService.getAnalyticsSummary());
    }
}
