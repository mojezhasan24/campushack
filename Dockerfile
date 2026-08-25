# Multi-stage Dockerfile for CampusHack Spring Boot Application
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/campushack-1.0.0.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
