package com.hackathon.repository;

import com.hackathon.entity.Team;
import com.hackathon.entity.Hackathon;
import com.hackathon.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface TeamRepository extends JpaRepository<Team, Long> {
    Optional<Team> findByInviteCode(String inviteCode);
    List<Team> findByHackathon(Hackathon hackathon);
    List<Team> findByLeader(User leader);
    List<Team> findByMembersContaining(User member);
}
