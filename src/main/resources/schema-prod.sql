-- Database schema for Campushack Production (PostgreSQL)
-- TODO: Replace with Flyway migrations in a later phase

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    roll_number VARCHAR(255),
    branch VARCHAR(255),
    year_of_study VARCHAR(255),
    role VARCHAR(50) NOT NULL,
    otp_code VARCHAR(255),
    otp_expiry TIMESTAMP,
    enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS student_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    full_name VARCHAR(255),
    college VARCHAR(255),
    branch VARCHAR(255),
    course VARCHAR(255),
    experience_years INT,
    bio TEXT,
    skills TEXT,
    tech_stack TEXT,
    github VARCHAR(255),
    linkedin VARCHAR(255),
    portfolio VARCHAR(255),
    projects TEXT,
    looking_for_team BOOLEAN DEFAULT FALSE,
    looking_role VARCHAR(255),
    looking_intro TEXT,
    looking_skills TEXT
);

CREATE TABLE IF NOT EXISTS hackathons (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    status VARCHAR(50),
    max_team_size INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS teams (
    id BIGSERIAL PRIMARY KEY,
    hackathon_id BIGINT REFERENCES hackathons(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    creator_id BIGINT REFERENCES users(id),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS team_members (
    team_id BIGINT REFERENCES teams(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (team_id, user_id)
);

CREATE TABLE IF NOT EXISTS team_workspaces (
    id BIGSERIAL PRIMARY KEY,
    team_id BIGINT UNIQUE REFERENCES teams(id) ON DELETE CASCADE,
    repository_url VARCHAR(255),
    project_description TEXT,
    tech_stack TEXT
);

CREATE TABLE IF NOT EXISTS recruitment_posts (
    id BIGSERIAL PRIMARY KEY,
    team_id BIGINT REFERENCES teams(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    required_skills TEXT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS recruitment_applications (
    id BIGSERIAL PRIMARY KEY,
    post_id BIGINT REFERENCES recruitment_posts(id) ON DELETE CASCADE,
    applicant_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    message TEXT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS recruitment_invitations (
    id BIGSERIAL PRIMARY KEY,
    team_id BIGINT REFERENCES teams(id) ON DELETE CASCADE,
    invitee_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS external_achievements (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    hackathon_name VARCHAR(255) NOT NULL,
    organizer VARCHAR(255),
    date VARCHAR(255),
    project_title VARCHAR(255),
    project_repo_link VARCHAR(255),
    demo_link VARCHAR(255),
    certificate_path VARCHAR(500),
    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS in_app_notifications (
    id BIGSERIAL PRIMARY KEY,
    recipient_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
