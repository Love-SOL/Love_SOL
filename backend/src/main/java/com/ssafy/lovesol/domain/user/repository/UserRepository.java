package com.ssafy.lovesol.domain.user.repository;

import com.ssafy.lovesol.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findById(String userId);
    Optional<User> findByUserId(long userid);
    List<User> findAllByDepositAt(int depositAt);
    Optional<User> findByLoginId(String loginId);
    Optional<User> findByIdAndPassword(String id , String password);
}
