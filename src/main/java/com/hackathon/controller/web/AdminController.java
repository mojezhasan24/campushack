package com.hackathon.controller.web;

import com.hackathon.entity.Hackathon;
import com.hackathon.entity.HackathonStatus;
import com.hackathon.entity.Role;
import com.hackathon.entity.User;
import com.hackathon.service.HackathonService;
import com.hackathon.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final HackathonService hackathonService;
    private final UserService userService;

    @GetMapping("/dashboard")
    public String adminDashboard(Model model) {
        Map<String, Object> analytics = hackathonService.getAnalyticsSummary();
        model.addAttribute("analytics", analytics);
        model.addAttribute("hackathons", hackathonService.getAllHackathons());
        return "admin_analytics";
    }

    @GetMapping("/analytics")
    public String adminAnalytics(Model model) {
        return adminDashboard(model);
    }

    @GetMapping("/hackathons")
    public String adminHackathons(Model model) {
        model.addAttribute("hackathons", hackathonService.getAllHackathons());
        return "admin_hackathons";
    }

    @PostMapping("/hackathons/save")
    public String saveHackathon(@ModelAttribute Hackathon hackathon, RedirectAttributes redirectAttributes) {
        try {
            if (hackathon.getId() == null) {
                hackathonService.createHackathon(hackathon);
                redirectAttributes.addFlashAttribute("successMessage", "Hackathon created successfully.");
            } else {
                hackathonService.updateHackathon(hackathon.getId(), hackathon);
                redirectAttributes.addFlashAttribute("successMessage", "Hackathon updated successfully.");
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/hackathons";
    }

    @PostMapping("/hackathons/delete/{id}")
    public String deleteHackathon(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            hackathonService.deleteHackathon(id);
            redirectAttributes.addFlashAttribute("successMessage", "Hackathon deleted successfully.");
        } catch (IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting hackathon: " + ex.getMessage());
        }
        return "redirect:/admin/hackathons";
    }

    @GetMapping("/users")
    public String adminUsers(@RequestParam(required = false) String search,
                             @RequestParam(required = false) Role role,
                             Model model) {
        List<User> users = userService.searchUsers(search, role);
        model.addAttribute("users", users);
        model.addAttribute("search", search);
        model.addAttribute("selectedRole", role);
        return "admin_users";
    }

    @PostMapping("/users/toggle-enable/{id}")
    public String toggleUserEnabled(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User loggedIn = (User) session.getAttribute("user");
        try {
            userService.toggleUserEnabled(id, loggedIn.getId());
            redirectAttributes.addFlashAttribute("successMessage", "User status updated successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/users/change-role/{id}")
    public String changeUserRole(@PathVariable Long id,
                                 @RequestParam Role newRole,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User loggedIn = (User) session.getAttribute("user");
        try {
            userService.updateUserRole(id, newRole, loggedIn.getId());
            redirectAttributes.addFlashAttribute("successMessage", "User role updated successfully.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/export/students")
    public ResponseEntity<byte[]> exportStudentsCsv(
            @RequestParam(required = false) Long hackathonId,
            @RequestParam(required = false) String branch,
            @RequestParam(required = false) String yearOfStudy,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate registeredAfter,
            @RequestParam(required = false, defaultValue = "false") Boolean last3Hackathons) {

        String csvData = userService.exportStudentDataCsv(hackathonId, branch, yearOfStudy, registeredAfter, last3Hackathons);
        byte[] csvBytes = csvData.getBytes(StandardCharsets.UTF_8);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"campushack_students_export.csv\"")
                .contentType(MediaType.parseMediaType("text/csv; charset=UTF-8"))
                .body(csvBytes);
    }
}
