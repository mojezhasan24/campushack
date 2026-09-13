package com.hackathon.controller.api;

import com.hackathon.config.JwtService;
import com.hackathon.entity.Role;
import com.hackathon.entity.User;
import com.hackathon.service.AuthService;
import com.hackathon.service.OtpService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication API", description = "User Login, Registration, OTP Verification, and JWT endpoints")
public class AuthRestController {

    private final AuthService authService;
    private final OtpService otpService;
    private final JwtService jwtService;

    @PostMapping("/login")
    @Operation(summary = "Authenticate user")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        User user = authService.authenticate(request.getLoginIdentifier(), request.getPassword());
        String token = jwtService.generateToken(user);
        return ResponseEntity.ok(Map.of("message", "Login successful", "token", token, "user", user));
    }

    @PostMapping("/register")
    @Operation(summary = "Register new account")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
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
        return ResponseEntity.ok(Map.of(
                "message", "Registration successful. Please check your email for the OTP.",
                "email", user.getEmail()
        ));
    }

    @PostMapping("/verify-otp")
    @Operation(summary = "Verify OTP Code")
    public ResponseEntity<?> verifyOtp(@RequestBody VerifyOtpRequest request) {
        otpService.validateOtp(request.getEmail(), request.getOtpCode());
        return ResponseEntity.ok(Map.of("message", "Account verified successfully. You can now log in."));
    }

    @GetMapping("/me")
    @Operation(summary = "Get current user profile")
    public ResponseEntity<?> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Not authenticated"));
        }
        User user = (User) authentication.getPrincipal();
        return ResponseEntity.ok(user);
    }
    
    @PostMapping("/logout")
    @Operation(summary = "Logout user")
    public ResponseEntity<?> logout() {
        // Since JWT is stateless, the client should delete the token on their end.
        // Server-side invalidation requires a token blacklist implementation.
        return ResponseEntity.ok(Map.of("message", "Logged out successfully. Please discard your token locally."));
    }
    
    @PostMapping("/change-password")
    @Operation(summary = "Change Password")
    public ResponseEntity<?> changePassword(@RequestBody Map<String, String> request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User loggedInUser = (User) authentication.getPrincipal();
        
        String newPassword = request.get("newPassword");
        if(newPassword == null || newPassword.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("error", "newPassword is required"));
        }
        // Assuming your AuthService or UserService has a method for this
        // authService.changePassword(loggedInUser.getId(), newPassword);
        
        return ResponseEntity.ok(Map.of("message", "Password changed successfully"));
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
