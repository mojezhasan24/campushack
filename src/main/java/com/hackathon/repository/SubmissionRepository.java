package com.hackathon.repository;

import com.hackathon.entity.Submission;
import com.hackathon.entity.Hackathon;
import com.hackathon.entity.Team;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface SubmissionRepository extends JpaRepository<Submission, Long> {
    List<Submission> findByHackathon(Hackathon hackathon);
    Optional<Submission> findByTeam(Team team);
    Optional<Submission> findByHackathonAndTeam(Hackathon hackathon, Team team);
}
