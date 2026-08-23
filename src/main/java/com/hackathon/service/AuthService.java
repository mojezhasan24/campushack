package com.hackathon.service;

import com.hackathon.entity.Role;
import com.hackathon.entity.User;
import com.hackathon.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final OtpService otpService;

    public User registerUser(String username, String password, String fullName, String email, String rollNumber, String branch, String yearOfStudy, Role role) {
        if (userRepository.findByUsername(username).isPresent()) {
            throw new IllegalArgumentException("Username '" + username + "' is already taken.");
        }
        if (userRepository.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Email '" + email + "' is already registered.");
        }
        if (rollNumber != null && !rollNumber.isBlank() && userRepository.findByRollNumber(rollNumber).isPresent()) {
            throw new IllegalArgumentException("Roll Number '" + rollNumber + "' is already registered.");
        }

        String otp = otpService.generateOtp();

        User user = User.builder()
                .username(username)
                .password(password)
                .fullName(fullName)
                .email(email)
                .rollNumber(rollNumber)
                .branch(branch)
                .yearOfStudy(yearOfStudy)
                .role(role != null ? role : Role.PARTICIPANT)
                .otpCode(otp)
                .otpExpiry(LocalDateTime.now().plusMinutes(10))
                .enabled(false)
                .build();

        User savedUser = userRepository.save(user);

        // Send OTP email
        otpService.sendOtpEmail(email, otp);

        return savedUser;
    }

    public User authenticate(String loginIdentifier, String password) {
        Optional<User> userOpt = userRepository.findByUsername(loginIdentifier);
        if (userOpt.isEmpty()) {
            userOpt = userRepository.findByRollNumber(loginIdentifier);
        }
        if (userOpt.isEmpty()) {
            userOpt = userRepository.findByEmail(loginIdentifier);
        }

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getPassword().equals(password)) {
                if (!user.isEnabled()) {
                    throw new IllegalStateException("Account not verified. Please check your email for the OTP.");
                }
                return user;
            }
        }
        throw new IllegalArgumentException("Invalid username/email/roll number or password.");
    }

    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + id));
    }
}
