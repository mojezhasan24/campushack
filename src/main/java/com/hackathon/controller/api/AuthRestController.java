package com.hackathon.controller.api;

import com.hackathon.entity.Role;
import com.hackathon.entity.User;
import com.hackathon.service.AuthService;
import com.hackathon.service.OtpService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpSession;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication API", description = "User Login, Registration, OTP Verification, and Session endpoints")
public class AuthRestController {

    private final AuthService authService;
    private final OtpService otpService;

    @PostMapping("/login")
    @Operation(summary = "Authenticate user", description = "Login using username, email, or roll number and password")
    public ResponseEntity<?> login(@RequestBody LoginRequest request, HttpSession session) {
        try {
            User user = authService.authenticate(request.getLoginIdentifier(), request.getPassword());
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("role", user.getRole().name());
            return ResponseEntity.ok(Map.of("message", "Login successful", "user", user));
        } catch (IllegalStateException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Unverified Account", "message", ex.getMessage()));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Unauthorized", "message", ex.getMessage()));
        }
    }

    @PostMapping("/register")
    @Operation(summary = "Register new account", description = "Register a new user account (Student, or Admin) and dispatch 6-digit OTP email")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request, HttpSession session) {
        User user = authService.registerUser(
                request.getUsername(),
                request.getPassword(),
                request.getFullName(),
                request.getEmail(),
                request.getRollNumber(),
                request.getBranch(),
                request.getYearOfStudy(),
                request.getRole() != null ? request.getRole() : Role.PARTICIPANT
        );
        session.setAttribute("pendingVerificationEmail", user.getEmail());
        return ResponseEntity.ok(Map.of(
                "message", "Registration successful. Please check your email for the OTP.",
                "email", user.getEmail()
        ));
    }

    @PostMapping("/verify-otp")
    @Operation(summary = "Verify OTP Code", description = "Validate 6-digit OTP code to enable user account")
    public ResponseEntity<?> verifyOtp(@RequestBody VerifyOtpRequest request) {
        otpService.validateOtp(request.getEmail(), request.getOtpCode());
        return ResponseEntity.ok(Map.of("message", "Account verified successfully. You can now log in."));
    }

    @PostMapping("/logout")
    @Operation(summary = "Logout user", description = "Invalidate user HTTP session")
    public ResponseEntity<?> logout(HttpSession session) {
        session.invalidate();
        return ResponseEntity.ok(Map.of("message", "Logged out successfully"));
    }

    @GetMapping("/me")
    @Operation(summary = "Get current user profile", description = "Retrieve logged-in user session data")
    public ResponseEntity<?> getCurrentUser(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Not authenticated"));
        }
        return ResponseEntity.ok(user);
    }

    @Data
    public static class LoginRequest {
        private String loginIdentifier;
        private String password;
    }

    @Data
    public static class RegisterRequest {
        private String username;
        private String password;
        private String fullName;
        private String email;
        private String rollNumber;
        private String branch;
        private String yearOfStudy;
        private Role role;
    }

    @Data
    public static class VerifyOtpRequest {
        private String email;
        private String otpCode;
    }
}
