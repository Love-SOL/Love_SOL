package com.ssafy.lovesol.domain.user.repository;

import com.ssafy.lovesol.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
