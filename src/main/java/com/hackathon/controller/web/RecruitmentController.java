package com.hackathon.controller.web;

import com.hackathon.entity.*;
import com.hackathon.repository.*;
import com.hackathon.service.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class RecruitmentController {

    private final RecruitmentService recruitmentService;
    private final HackathonService hackathonService;
    private final ProfileService profileService;
    private final TeamWorkspaceRepository teamWorkspaceRepository;
    private final TeamRepository teamRepository;

    @GetMapping("/recruitment/browse")
    public String browsePosts(
            @RequestParam(required = false) Long hackathonId,
            @RequestParam(required = false) Boolean onlinePref,
            @RequestParam(required = false) String experienceLevel,
            Model model
    ) {
        List<RecruitmentPost> posts = recruitmentService.filterPosts(hackathonId, onlinePref, experienceLevel);
        model.addAttribute("posts", posts);
        model.addAttribute("hackathons", hackathonService.getAllHackathons());
        return "recruitment_browse";
    }

    @GetMapping("/recruitment/create")
    public String createPostForm(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }
        List<Hackathon> hackathons = hackathonService.getAllHackathons();
        List<Team> teams = teamRepository.findByLeader(loggedInUser);

        if (teams.isEmpty()) {
            model.addAttribute("error", "You must be a Team Leader of at least one team to post a recruitment listing.");
        }

        model.addAttribute("hackathons", hackathons);
        model.addAttribute("teams", teams);
        return "recruitment_create";
    }

    @PostMapping("/recruitment/create")
    public String handleCreatePost(
            @RequestParam Long hackathonId,
            @RequestParam Long teamId,
            @RequestParam String title,
            @RequestParam String requiredSkills,
            @RequestParam(required = false) String preferredSkills,
            @RequestParam String requiredRoles,
            @RequestParam(required = false) String experienceLevel,
            @RequestParam(required = false) String locationPref,
            @RequestParam(defaultValue = "true") boolean onlinePref,
            @RequestParam String description,
            @RequestParam String projectDescription,
            @RequestParam String applicationDeadline,
            @RequestParam(required = false) String additionalRequirements,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model
    ) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        try {
            LocalDate deadline = LocalDate.parse(applicationDeadline);
            recruitmentService.createPost(
                    hackathonId, teamId, loggedInUser.getId(), title,
                    requiredSkills, preferredSkills, requiredRoles, experienceLevel,
                    locationPref, onlinePref, description, projectDescription,
                    deadline, additionalRequirements
            );
            redirectAttributes.addFlashAttribute("successMessage", "Recruitment listing published successfully! 🚀");
            return "redirect:/recruitment/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("hackathons", hackathonService.getAllHackathons());
            model.addAttribute("teams", teamRepository.findByLeader(loggedInUser));
            return "recruitment_create";
        }
    }

    @GetMapping("/recruitment/view/{id}")
    public String viewPostDetail(@PathVariable Long id, HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        RecruitmentPost post = recruitmentService.getPostById(id);
        model.addAttribute("post", post);

        if (loggedInUser != null) {
            StudentProfile profile = profileService.getProfileByUser(loggedInUser);
            model.addAttribute("studentProfile", profile);
        }
        return "recruitment_detail";
    }

    @PostMapping("/recruitment/apply")
    public String handleApply(
            @RequestParam Long postId,
            @RequestParam String message,
            @RequestParam String contribution,
            @RequestParam String relevantSkills,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        try {
            recruitmentService.submitApplication(postId, loggedInUser.getId(), message, contribution, relevantSkills);
            redirectAttributes.addFlashAttribute("successMessage", "Application submitted successfully! ⚡");
            return "redirect:/recruitment/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/recruitment/view/" + postId;
        }
    }

    @GetMapping("/recruitment/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        List<RecruitmentPost> myPosts = recruitmentService.getPostsByLeader(loggedInUser);
        List<Application> myApplications = recruitmentService.getApplicationsByApplicant(loggedInUser);
        List<Invitation> myInvitations = recruitmentService.getUserInvitations(loggedInUser);

        model.addAttribute("myPosts", myPosts);
        model.addAttribute("myApplications", myApplications);
        model.addAttribute("myInvitations", myInvitations);
        return "recruitment_dashboard";
    }

    @GetMapping("/recruitment/manage/{postId}")
    public String managePostApplications(@PathVariable Long postId, HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        RecruitmentPost post = recruitmentService.getPostById(postId);
        List<Application> applications = recruitmentService.getApplicationsForPost(postId, loggedInUser.getId());

        model.addAttribute("post", post);
        model.addAttribute("applications", applications);
        return "recruitment_manage";
    }

    @PostMapping("/recruitment/accept")
    public String acceptApplication(
            @RequestParam Long applicationId,
            @RequestParam Long postId,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        try {
            recruitmentService.acceptApplication(applicationId, loggedInUser.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Application accepted! Student added to team. 🎉");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/recruitment/manage/" + postId;
    }

    @PostMapping("/recruitment/reject")
    public String rejectApplication(
            @RequestParam Long applicationId,
            @RequestParam Long postId,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        try {
            recruitmentService.rejectApplication(applicationId, loggedInUser.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Application rejected.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/recruitment/manage/" + postId;
    }

    @GetMapping("/workspace/{teamId}")
    public String viewWorkspace(@PathVariable Long teamId, HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        TeamWorkspace workspace = teamWorkspaceRepository.findByTeamId(teamId)
                .orElseThrow(() -> new IllegalArgumentException("Team workspace not found for team ID: " + teamId));

        model.addAttribute("workspace", workspace);
        return "workspace";
    }
}
