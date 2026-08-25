package com.hackathon.service;

import com.hackathon.entity.StudentProfile;
import com.hackathon.entity.User;
import com.hackathon.repository.StudentProfileRepository;
import com.hackathon.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProfileService {

    private final StudentProfileRepository studentProfileRepository;
    private final UserRepository userRepository;

    public StudentProfile getProfileByUser(User user) {
        return studentProfileRepository.findByUser(user)
                .orElseGet(() -> createDefaultProfile(user));
    }

    public StudentProfile getProfileByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));
        return getProfileByUser(user);
    }

    @Transactional
    public StudentProfile createDefaultProfile(User user) {
        StudentProfile profile = StudentProfile.builder()
                .user(user)
                .college("Campus Technology Institute")
                .branch(user.getBranch() != null ? user.getBranch() : "Computer Science")
                .course(user.getYearOfStudy() != null ? user.getYearOfStudy() : "B.Tech")
                .skills("Java, React, SQL")
                .techStack("Spring Boot, Full Stack")
                .experienceYears(1)
                .bio("Enthusiastic hackathon builder passionate about solving real-world problems.")
                .lookingForTeam(false)
                .build();
        return studentProfileRepository.save(profile);
    }

    @Transactional
    public StudentProfile updateProfile(StudentProfile profile) {
        return studentProfileRepository.save(profile);
    }

    @Transactional
    public StudentProfile toggleLookingForTeam(Long userId, boolean looking, String lookingRole, String lookingIntro, String lookingSkills) {
        StudentProfile profile = getProfileByUserId(userId);
        profile.setLookingForTeam(looking);
        if (lookingRole != null) profile.setLookingRole(lookingRole);
        if (lookingIntro != null) profile.setLookingIntro(lookingIntro);
        if (lookingSkills != null) profile.setLookingSkills(lookingSkills);
        return studentProfileRepository.save(profile);
    }

    public List<StudentProfile> getAvailableCandidates() {
        return studentProfileRepository.findByLookingForTeamTrue();
    }
}
