package com.hackathon.repository;

import com.hackathon.dto.StudentExportDTO;
import com.hackathon.entity.User;
import com.hackathon.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Optional<User> findByRollNumber(String rollNumber);
    Optional<User> findByEmail(String email);
    List<User> findByRole(Role role);
    List<User> findTop5ByOrderByIdDesc();

    @Query("SELECT u FROM User u WHERE " +
           "(:role IS NULL OR u.role = :role) AND " +
           "(:query IS NULL OR :query = '' OR LOWER(u.username) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(u.email) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(u.fullName) LIKE LOWER(CONCAT('%', :query, '%')))")
    List<User> searchUsers(@Param("query") String query, @Param("role") Role role);

    @Query("SELECT new com.hackathon.dto.StudentExportDTO(" +
           "u.username, u.fullName, u.email, u.branch, u.yearOfStudy, h.title, t.teamName, u.createdAt) " +
           "FROM Team t " +
           "JOIN t.members u " +
           "JOIN t.hackathon h " +
           "WHERE h.deleted = false AND " +
           "(:hackathonId IS NULL OR h.id = :hackathonId) AND " +
           "(:branch IS NULL OR :branch = '' OR u.branch = :branch) AND " +
           "(:yearOfStudy IS NULL OR :yearOfStudy = '' OR u.yearOfStudy = :yearOfStudy) AND " +
           "(:registeredAfter IS NULL OR u.createdAt >= :registeredAfter) AND " +
           "(:hackathonIds IS NULL OR h.id IN :hackathonIds)")
    List<StudentExportDTO> findStudentExportData(
            @Param("hackathonId") Long hackathonId,
            @Param("branch") String branch,
            @Param("yearOfStudy") String yearOfStudy,
            @Param("registeredAfter") LocalDateTime registeredAfter,
            @Param("hackathonIds") List<Long> hackathonIds);

    @Query("SELECT u.branch, COUNT(u) FROM User u WHERE u.branch IS NOT NULL GROUP BY u.branch")
    List<Object[]> getBranchDistribution();
}

