package com.hackathon.repository;

import com.hackathon.entity.Invitation;
import com.hackathon.entity.RecruitmentPost;
import com.hackathon.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InvitationRepository extends JpaRepository<Invitation, Long> {

    List<Invitation> findByInvitedUserOrderByCreatedAtDesc(User invitedUser);

    List<Invitation> findByTeamLeadOrderByCreatedAtDesc(User teamLead);

    Optional<Invitation> findByRecruitmentPostAndInvitedUser(RecruitmentPost post, User invitedUser);
}
