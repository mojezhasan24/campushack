package com.hackathon.controller.web;

import com.hackathon.entity.StudentProfile;
import com.hackathon.entity.User;
import com.hackathon.service.ProfileService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/profile")
@RequiredArgsConstructor
public class ProfileController {

    private final ProfileService profileService;

    @GetMapping("/view/{userId}")
    public String viewProfile(@PathVariable Long userId, Model model, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }
        StudentProfile profile = profileService.getProfileByUserId(userId);
        model.addAttribute("profile", profile);
        model.addAttribute("isSelf", loggedInUser.getId().equals(userId));
        return "profile_view";
    }

    @GetMapping("/edit")
    public String editProfileForm(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }
        StudentProfile profile = profileService.getProfileByUser(loggedInUser);
        model.addAttribute("profile", profile);
        return "profile_edit";
    }

    @PostMapping("/edit")
    public String handleEditProfile(
            @RequestParam(required = false) String college,
            @RequestParam(required = false) String branch,
            @RequestParam(required = false) String course,
            @RequestParam(required = false) String skills,
            @RequestParam(required = false) String techStack,
            @RequestParam(required = false) Integer experienceYears,
            @RequestParam(required = false) String bio,
            @RequestParam(required = false) String github,
            @RequestParam(required = false) String linkedin,
            @RequestParam(required = false) String portfolio,
            @RequestParam(required = false) String projects,
            @RequestParam(defaultValue = "false") boolean lookingForTeam,
            @RequestParam(required = false) String lookingRole,
            @RequestParam(required = false) String lookingIntro,
            @RequestParam(required = false) String lookingSkills,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        StudentProfile profile = profileService.getProfileByUser(loggedInUser);
        if (college != null) profile.setCollege(college);
        if (branch != null) profile.setBranch(branch);
        if (course != null) profile.setCourse(course);
        if (skills != null) profile.setSkills(skills);
        if (techStack != null) profile.setTechStack(techStack);
        if (experienceYears != null) profile.setExperienceYears(experienceYears);
        if (bio != null) profile.setBio(bio);
        if (github != null) profile.setGithub(github);
        if (linkedin != null) profile.setLinkedin(linkedin);
        if (portfolio != null) profile.setPortfolio(portfolio);
        if (projects != null) profile.setProjects(projects);

        profile.setLookingForTeam(lookingForTeam);
        if (lookingRole != null) profile.setLookingRole(lookingRole);
        if (lookingIntro != null) profile.setLookingIntro(lookingIntro);
        if (lookingSkills != null) profile.setLookingSkills(lookingSkills);

        profileService.updateProfile(profile);
        redirectAttributes.addFlashAttribute("successMessage", "Profile successfully updated! ✨");
        return "redirect:/profile/view/" + loggedInUser.getId();
    }

    @GetMapping("/talent-search")
    public String talentSearch(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }
        List<StudentProfile> candidates = profileService.getAvailableCandidates();
        model.addAttribute("candidates", candidates);
        return "talent_search";
    }
}
