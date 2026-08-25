package com.hackathon.service;

import com.hackathon.entity.*;
import com.hackathon.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RecruitmentService {

    private final RecruitmentPostRepository recruitmentPostRepository;
    private final ApplicationRepository applicationRepository;
    private final InvitationRepository invitationRepository;
    private final TeamWorkspaceRepository teamWorkspaceRepository;
    private final HackathonRepository hackathonRepository;
    private final TeamRepository teamRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    @Transactional
    public RecruitmentPost createPost(
            Long hackathonId,
            Long teamId,
            Long leaderId,
            String title,
            String requiredSkills,
            String preferredSkills,
            String requiredRoles,
            String experienceLevel,
            String locationPref,
            boolean onlinePref,
            String description,
            String projectDescription,
            LocalDate applicationDeadline,
            String additionalRequirements
    ) {
        Hackathon hackathon = hackathonRepository.findById(hackathonId)
                .orElseThrow(() -> new IllegalArgumentException("Hackathon not found with ID: " + hackathonId));

        Team team = teamRepository.findById(teamId)
                .orElseThrow(() -> new IllegalArgumentException("Team not found with ID: " + teamId));

        User leader = userRepository.findById(leaderId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + leaderId));

        if (!team.getLeader().getId().equals(leader.getId())) {
            throw new IllegalStateException("Only the team leader can create a recruitment post for this team.");
        }

        int currentSize = team.getMembers() != null && !team.getMembers().isEmpty()
                ? team.getMembers().size()
                : 1;

        int maxSize = hackathon.getMaxTeamSize() != null ? hackathon.getMaxTeamSize() : 4;

        RecruitmentPost post = RecruitmentPost.builder()
                .hackathon(hackathon)
                .team(team)
                .teamLead(leader)
                .title(title)
                .currentSize(currentSize)
                .maxSize(maxSize)
                .requiredSkills(requiredSkills)
                .preferredSkills(preferredSkills)
                .requiredRoles(requiredRoles)
                .experienceLevel(experienceLevel)
                .locationPref(locationPref)
                .onlinePref(onlinePref)
                .description(description)
                .projectDescription(projectDescription)
                .applicationDeadline(applicationDeadline)
                .additionalRequirements(additionalRequirements)
                .status("OPEN")
                .build();

        return recruitmentPostRepository.save(post);
    }

    public List<RecruitmentPost> getAllActivePosts() {
        return recruitmentPostRepository.findByStatusOrderByCreatedAtDesc("OPEN");
    }

    public List<RecruitmentPost> getPostsByLeader(User leader) {
        return recruitmentPostRepository.findByTeamLeadOrderByCreatedAtDesc(leader);
    }

    public RecruitmentPost getPostById(Long id) {
        return recruitmentPostRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Recruitment post not found with ID: " + id));
    }

    public List<RecruitmentPost> filterPosts(Long hackathonId, Boolean onlinePref, String experienceLevel) {
        return recruitmentPostRepository.filterPosts("OPEN", hackathonId, onlinePref, experienceLevel);
    }

    @Transactional
    public void closePost(Long postId, Long leaderId) {
        RecruitmentPost post = getPostById(postId);
        if (!post.getTeamLead().getId().equals(leaderId)) {
            throw new IllegalStateException("Only the team leader can close this recruitment post.");
        }
        post.setStatus("CLOSED");
        recruitmentPostRepository.save(post);
    }

    @Transactional
    public Application submitApplication(Long postId, Long applicantId, String message, String contribution, String relevantSkills) {
        RecruitmentPost post = getPostById(postId);
        User applicant = userRepository.findById(applicantId)
                .orElseThrow(() -> new IllegalArgumentException("Applicant not found with ID: " + applicantId));

        // Rule 1: Cannot apply if post is closed
        if (!"OPEN".equalsIgnoreCase(post.getStatus())) {
            throw new IllegalStateException("This recruitment post is no longer open for applications.");
        }

        // Rule 2: Cannot apply to own team
        if (post.getTeamLead().getId().equals(applicantId)) {
            throw new IllegalStateException("You cannot apply to your own team post.");
        }

        // Rule 3: Cannot apply twice to same post
        if (applicationRepository.findByRecruitmentPostAndApplicant(post, applicant).isPresent()) {
            throw new IllegalStateException("You have already submitted an application for this team.");
        }

        // Rule 4: Max 5 active pending applications
        long pendingCount = applicationRepository.countByApplicantAndStatus(applicant, "PENDING");
        if (pendingCount >= 5) {
            throw new IllegalStateException("You have reached the maximum limit of 5 active applications.");
        }

        Application application = Application.builder()
                .recruitmentPost(post)
                .applicant(applicant)
                .message(message)
                .contribution(contribution)
                .relevantSkills(relevantSkills)
                .status("PENDING")
                .build();

        Application saved = applicationRepository.save(application);

        // Notify Team Lead
        notificationService.createNotification(
                post.getTeamLead(),
                "New application received from " + applicant.getFullName() + " for team: " + post.getTeam().getTeamName(),
                "APPLICATION",
                "/recruitment/manage/" + post.getId()
        );

        return saved;
    }

    public List<Application> getApplicationsForPost(Long postId, Long leaderId) {
        RecruitmentPost post = getPostById(postId);
        if (!post.getTeamLead().getId().equals(leaderId)) {
            throw new IllegalStateException("Unauthorized to view applications for this post.");
        }
        return applicationRepository.findByRecruitmentPostOrderByCreatedAtDesc(post);
    }

    public List<Application> getApplicationsByApplicant(User applicant) {
        return applicationRepository.findByApplicantOrderByCreatedAtDesc(applicant);
    }

    @Transactional
    public void acceptApplication(Long applicationId, Long leaderId) {
        Application application = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new IllegalArgumentException("Application not found with ID: " + applicationId));
        RecruitmentPost post = application.getRecruitmentPost();

        if (!post.getTeamLead().getId().equals(leaderId)) {
            throw new IllegalStateException("Only the team leader can accept applications.");
        }

        application.setStatus("ACCEPTED");
        applicationRepository.save(application);

        // Add member to team
        Team team = post.getTeam();
        team.getMembers().add(application.getApplicant());
        teamRepository.save(team);

        // Update post size
        post.setCurrentSize(team.getMembers().size());
        if (post.getCurrentSize() >= post.getMaxSize()) {
            post.setStatus("CLOSED");
        }
        recruitmentPostRepository.save(post);

        // Ensure TeamWorkspace exists
        ensureWorkspaceExists(team, post.getProjectDescription());

        // Notify applicant
        notificationService.createNotification(
                application.getApplicant(),
                "🎉 Congratulations! Your application to join team '" + team.getTeamName() + "' was accepted!",
                "TEAM_UPDATE",
                "/workspace/" + team.getId()
        );
    }

    @Transactional
    public void rejectApplication(Long applicationId, Long leaderId) {
        Application application = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new IllegalArgumentException("Application not found with ID: " + applicationId));
        RecruitmentPost post = application.getRecruitmentPost();

        if (!post.getTeamLead().getId().equals(leaderId)) {
            throw new IllegalStateException("Only the team leader can reject applications.");
        }

        application.setStatus("REJECTED");
        applicationRepository.save(application);

        notificationService.createNotification(
                application.getApplicant(),
                "Your application for team '" + post.getTeam().getTeamName() + "' was not accepted.",
                "APPLICATION",
                "/recruitment/browse"
        );
    }

    @Transactional
    public Invitation sendInvitation(Long postId, Long leaderId, Long invitedUserId, String message) {
        RecruitmentPost post = getPostById(postId);
        User leader = userRepository.findById(leaderId).orElseThrow();
        User invitedUser = userRepository.findById(invitedUserId).orElseThrow();

        if (!post.getTeamLead().getId().equals(leaderId)) {
            throw new IllegalStateException("Only team leader can send invitations.");
        }

        Invitation invitation = Invitation.builder()
                .recruitmentPost(post)
                .teamLead(leader)
                .invitedUser(invitedUser)
                .message(message)
                .status("PENDING")
                .build();

        Invitation saved = invitationRepository.save(invitation);

        notificationService.createNotification(
                invitedUser,
                "📩 You received a team invitation from " + leader.getFullName() + " for team: " + post.getTeam().getTeamName(),
                "INVITATION",
                "/notifications"
        );

        return saved;
    }

    @Transactional
    public void respondInvitation(Long invitationId, Long userId, boolean accept) {
        Invitation invitation = invitationRepository.findById(invitationId)
                .orElseThrow(() -> new IllegalArgumentException("Invitation not found with ID: " + invitationId));

        if (!invitation.getInvitedUser().getId().equals(userId)) {
            throw new IllegalStateException("Unauthorized to respond to this invitation.");
        }

        if (accept) {
            invitation.setStatus("ACCEPTED");
            RecruitmentPost post = invitation.getRecruitmentPost();
            Team team = post.getTeam();
            team.getMembers().add(invitation.getInvitedUser());
            teamRepository.save(team);

            post.setCurrentSize(team.getMembers().size());
            if (post.getCurrentSize() >= post.getMaxSize()) {
                post.setStatus("CLOSED");
            }
            recruitmentPostRepository.save(post);
            ensureWorkspaceExists(team, post.getProjectDescription());

            notificationService.createNotification(
                    invitation.getTeamLead(),
                    "🎉 " + invitation.getInvitedUser().getFullName() + " accepted your team invitation!",
                    "TEAM_UPDATE",
                    "/workspace/" + team.getId()
            );
        } else {
            invitation.setStatus("REJECTED");
        }
        invitationRepository.save(invitation);
    }

    public List<Invitation> getUserInvitations(User user) {
        return invitationRepository.findByInvitedUserOrderByCreatedAtDesc(user);
    }

    private void ensureWorkspaceExists(Team team, String projectInfo) {
        if (teamWorkspaceRepository.findByTeam(team).isEmpty()) {
            TeamWorkspace workspace = TeamWorkspace.builder()
                    .team(team)
                    .description("Private team workspace for " + team.getTeamName())
                    .projectInfo(projectInfo != null ? projectInfo : "Hackathon Project Collaboration")
                    .submissionDeadline(LocalDate.now().plusDays(7))
                    .sharedLinks("GitHub: TBD | Discord: TBD | WhatsApp: TBD")
                    .taskBoard("Task 1: Project Architecture Setup [Pending]\nTask 2: UI Wireframes & Design System [In Progress]\nTask 3: Backend API Integration [Pending]")
                    .build();
            teamWorkspaceRepository.save(workspace);
        }
    }
}
