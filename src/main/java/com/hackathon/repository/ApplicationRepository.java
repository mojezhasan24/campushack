package com.hackathon.repository;

import com.hackathon.entity.Application;
import com.hackathon.entity.RecruitmentPost;
import com.hackathon.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ApplicationRepository extends JpaRepository<Application, Long> {

    List<Application> findByRecruitmentPostOrderByCreatedAtDesc(RecruitmentPost post);

    List<Application> findByApplicantOrderByCreatedAtDesc(User applicant);

    Optional<Application> findByRecruitmentPostAndApplicant(RecruitmentPost post, User applicant);

    long countByApplicantAndStatus(User applicant, String status);

    List<Application> findByRecruitmentPostAndStatus(RecruitmentPost post, String status);
}
