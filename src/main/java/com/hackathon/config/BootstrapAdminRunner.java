package com.hackathon.config;

import com.hackathon.entity.User;
import com.hackathon.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("prod")
@ConditionalOnProperty(name = "BOOTSTRAP_ADMIN", havingValue = "true")
public class BootstrapAdminRunner implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(BootstrapAdminRunner.class);

    @Autowired
    private UserRepository userRepository;

    @Value("${BOOTSTRAP_ADMIN_EMAIL:}")
    private String adminEmail;

    @Value("${BOOTSTRAP_ADMIN_PASSWORD:}")
    private String adminPassword;

    @Override
    public void run(String... args) throws Exception {
        if (adminEmail == null || adminEmail.isEmpty() || adminPassword == null || adminPassword.isEmpty()) {
            logger.warn("BOOTSTRAP_ADMIN is true, but BOOTSTRAP_ADMIN_EMAIL or BOOTSTRAP_ADMIN_PASSWORD is not set. Skipping admin creation.");
            return;
        }

        // Check if any admin exists
        boolean adminExists = userRepository.findAll().stream()
                .anyMatch(user -> "ADMIN".equals(user.getRole()));

        if (!adminExists) {
            User admin = new User();
            admin.setUsername(adminEmail);
            admin.setPassword(adminPassword); // NOTE: Ensure you add password hashing if not already configured in your system!
            admin.setRole("ADMIN");
            userRepository.save(admin);
            logger.info("Successfully created the initial bootstrap ADMIN user.");
        } else {
            logger.info("An ADMIN user already exists. Skipping bootstrap admin creation.");
        }
    }
}
