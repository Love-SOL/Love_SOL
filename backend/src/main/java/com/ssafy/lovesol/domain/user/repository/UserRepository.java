package com.ssafy.lovesol.domain.user.repository;

import com.ssafy.lovesol.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    List<User> findAllByDepositAt(int depositAt);

}
