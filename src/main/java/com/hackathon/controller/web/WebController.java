package com.hackathon.controller.web;

import com.hackathon.entity.*;
import com.hackathon.service.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class WebController {

    private final HackathonService hackathonService;
    private final RegistrationService registrationService;
    private final ExternalAchievementService externalAchievementService;

    @GetMapping("/")
    public String index(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/dashboard";
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @GetMapping("/verify-otp")
    public String verifyOtpPage() {
        return "verify-otp";
    }

    @GetMapping("/dashboard")
    public String dashboardPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Hackathon> hackathons = hackathonService.getAllHackathons();
        List<Team> userTeams = registrationService.getTeamsForUser(user);
        model.addAttribute("hackathons", hackathons);
        model.addAttribute("userTeams", userTeams);
        model.addAttribute("activeEventsCount", hackathons.stream().filter(h -> h.getStatus() == HackathonStatus.ACTIVE || h.getStatus() == HackathonStatus.UPCOMING).count());
        return "dashboard";
    }

    @GetMapping("/discover")
    public String discoveryPage(Model model) {
        model.addAttribute("hackathons", hackathonService.getAllHackathons());
        return "discovery";
    }

    @GetMapping("/hackathon/{id}")
    public String hackathonDetailPage(@PathVariable Long id, Model model) {
        Hackathon hackathon = hackathonService.getHackathonById(id);
        List<Team> teams = registrationService.getTeamsForHackathon(id);
        model.addAttribute("hackathon", hackathon);
        model.addAttribute("teams", teams);
        return "hackathon_detail";
    }

    @GetMapping("/student/achievements")
    public String studentAchievementsPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != Role.PARTICIPANT) {
            return "redirect:/login";
        }
        
        List<ExternalAchievement> achievements = externalAchievementService.getAchievementsByStudentId(user.getId());
        model.addAttribute("achievements", achievements);
        
        return "student_achievements";
    }

    @GetMapping("/admin/approvals")
    public String adminApprovalsPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        
        List<ExternalAchievement> pendingAchievements = externalAchievementService.getPendingAchievements();
        model.addAttribute("pendingAchievements", pendingAchievements);
        
        return "admin_approvals";
    }
}
