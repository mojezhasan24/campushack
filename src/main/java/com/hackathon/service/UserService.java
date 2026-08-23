package com.hackathon.service;

import com.hackathon.dto.StudentExportDTO;
import com.hackathon.entity.Hackathon;
import com.hackathon.entity.Role;
import com.hackathon.entity.User;
import com.hackathon.repository.HackathonRepository;
import com.hackathon.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final HackathonRepository hackathonRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public List<User> searchUsers(String query, Role role) {
        return userRepository.searchUsers(query, role);
    }

    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + id));
    }

    @Transactional
    public User toggleUserEnabled(Long userId, Long currentAdminId) {
        if (userId.equals(currentAdminId)) {
            throw new IllegalArgumentException("Admins cannot disable their own account.");
        }
        User user = getUserById(userId);
        user.setEnabled(!user.isEnabled());
        return userRepository.save(user);
    }

    @Transactional
    public User updateUserRole(Long userId, Role newRole, Long currentAdminId) {
        if (userId.equals(currentAdminId) && newRole != Role.ADMIN) {
            throw new IllegalArgumentException("Admins cannot demote their own account role.");
        }
        User user = getUserById(userId);
        user.setRole(newRole);
        return userRepository.save(user);
    }

    public String exportStudentDataCsv(Long hackathonId, String branch, String yearOfStudy, LocalDate registeredAfterDate, Boolean last3Hackathons) {
        LocalDateTime registeredAfter = registeredAfterDate != null ? registeredAfterDate.atStartOfDay() : null;
        List<Long> last3HackathonIds = null;

        if (Boolean.TRUE.equals(last3Hackathons)) {
            List<Hackathon> top3 = hackathonRepository.findTop3ByDeletedFalseOrderByStartDateDesc();
            last3HackathonIds = top3.stream().map(Hackathon::getId).collect(Collectors.toList());
            if (last3HackathonIds.isEmpty()) {
                last3HackathonIds = List.of(-1L);
            }
        }

        List<StudentExportDTO> students = userRepository.findStudentExportData(
                hackathonId,
                branch,
                yearOfStudy,
                registeredAfter,
                last3HackathonIds
        );

        StringBuilder csv = new StringBuilder();
        csv.append("Username,FullName,Email,Branch,Year,Hackathon Title,Team Name,Registration Date\n");

        for (StudentExportDTO dto : students) {
            csv.append(escapeCsv(dto.getUsername())).append(",")
               .append(escapeCsv(dto.getFullName())).append(",")
               .append(escapeCsv(dto.getEmail())).append(",")
               .append(escapeCsv(dto.getBranch())).append(",")
               .append(escapeCsv(dto.getYearOfStudy())).append(",")
               .append(escapeCsv(dto.getHackathonTitle())).append(",")
               .append(escapeCsv(dto.getTeamName())).append(",")
               .append(dto.getRegistrationDate() != null ? dto.getRegistrationDate().toString() : "").append("\n");
        }

        return csv.toString();
    }

    private String escapeCsv(String input) {
        if (input == null) return "";
        if (input.contains(",") || input.contains("\"") || input.contains("\n")) {
            return "\"" + input.replace("\"", "\"\"") + "\"";
        }
        return input;
    }
}
