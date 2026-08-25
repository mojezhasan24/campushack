package com.hackathon.repository;

import com.hackathon.entity.Team;
import com.hackathon.entity.TeamWorkspace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TeamWorkspaceRepository extends JpaRepository<TeamWorkspace, Long> {

    Optional<TeamWorkspace> findByTeam(Team team);

    Optional<TeamWorkspace> findByTeamId(Long teamId);
}
