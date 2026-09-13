package com.hackathon.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("CampusHack Management System REST API")
                        .version("1.0.0")
                        .description("REST API Documentation for CampusHack Hackathon Portal endpoints including Auth, Hackathons, Teams, and Submissions.")
                        .contact(new Contact()
                                .name("CampusHack Support")
                                .email("support@campushack.edu")));
    }
}
