package com.hackathon.service;

import com.hackathon.entity.User;
import com.hackathon.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class OtpService {

    private final UserRepository userRepository;
    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:campushack67@gmail.com}")
    private String fromEmail;

    public String generateOtp() {
        SecureRandom random = new SecureRandom();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    public void sendOtpEmail(String toEmail, String otp) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("CampusHack - Email Verification OTP");
            message.setText("Welcome to CampusHack!\n\nYour 6-digit Email Verification OTP is: " + otp + "\n\nThis OTP is valid for 10 minutes. Do not share it with anyone.");

            mailSender.send(message);
            log.info("OTP verification email sent to {}", toEmail);
        } catch (Exception ex) {
            log.error("Failed to send OTP email via SMTP to {}: {}. Note: Ensure EMAIL_PASSWORD env variable is set.", toEmail, ex.getMessage());
            // Log fallback for development testing
            System.out.println("=================================================");
            System.out.println(">>> OTP FOR " + toEmail + ": " + otp);
            System.out.println("=================================================");
        }
    }

    public boolean validateOtp(String email, String otpInput) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User with email '" + email + "' not found."));

        if (user.getOtpCode() == null || user.getOtpExpiry() == null) {
            throw new IllegalArgumentException("No pending OTP found for this account. Please register or request a new OTP.");
        }

        if (LocalDateTime.now().isAfter(user.getOtpExpiry())) {
            throw new IllegalArgumentException("OTP has expired. Please register again to receive a new OTP.");
        }

        if (!user.getOtpCode().equals(otpInput.trim())) {
            throw new IllegalArgumentException("Invalid OTP code. Please check your email and try again.");
        }

        user.setEnabled(true);
        user.setOtpCode(null);
        user.setOtpExpiry(null);
        userRepository.save(user);
        return true;
    }
}
