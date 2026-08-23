package com.hackathon.repository;

import com.hackathon.entity.Hackathon;
import com.hackathon.entity.HackathonStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface HackathonRepository extends JpaRepository<Hackathon, Long> {
    List<Hackathon> findByDeletedFalse();
    List<Hackathon> findByDeletedFalseOrderByStartDateDesc();
    List<Hackathon> findTop3ByDeletedFalseOrderByStartDateDesc();
    List<Hackathon> findTop5ByDeletedFalseOrderByIdDesc();
    long countByDeletedFalse();

    List<Hackathon> findByStatusAndDeletedFalse(HackathonStatus status);
    
    @Query("SELECT h FROM Hackathon h WHERE h.deleted = false AND (LOWER(h.title) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(h.category) LIKE LOWER(CONCAT('%', :query, '%')))")
    List<Hackathon> searchHackathons(@Param("query") String query);
}
