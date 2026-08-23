package com.hackathon.config;

import com.hackathon.entity.*;
import com.hackathon.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final HackathonRepository hackathonRepository;
    private final UserRepository userRepository;

    @Override
    public void run(String... args) throws Exception {
        if (userRepository.findByUsername("admin").isEmpty()) {
            userRepository.save(User.builder()
                    .username("admin")
                    .password("admin123")
                    .fullName("System Administrator")
                    .email("admin@campushack.com")
                    .role(Role.ADMIN)
                    .enabled(true)
                    .build());
            System.out.println(">>> CampusHack Initialized: Admin User created (Username: admin | Password: admin123).");
        }

        if (hackathonRepository.count() == 0) {
            hackathonRepository.save(Hackathon.builder()
                    .title("Spring Sprint '24")
                    .description("The annual flagship collegiate hackathon focusing on AI, Web3, and Open Source innovation.")
                    .category("Full Stack & AI")
                    .startDate(LocalDate.now().plusDays(5))
                    .endDate(LocalDate.now().plusDays(7))
                    .registrationDeadline(LocalDate.now().plusDays(4))
                    .prizePool(5000.0)
                    .maxTeamSize(4)
                    .status(HackathonStatus.ACTIVE)
                    .build());

            hackathonRepository.save(Hackathon.builder()
                    .title("Global AI Summit")
                    .description("Join the brightest minds to build next generation artificial intelligence and machine learning tools.")
                    .category("Artificial Intelligence")
                    .startDate(LocalDate.now().plusDays(10))
                    .endDate(LocalDate.now().plusDays(12))
                    .registrationDeadline(LocalDate.now().plusDays(8))
                    .prizePool(7500.0)
                    .maxTeamSize(4)
                    .status(HackathonStatus.UPCOMING)
                    .build());

            System.out.println(">>> CampusHack Initialized with Sample Hackathons.");
        }
    }
}

