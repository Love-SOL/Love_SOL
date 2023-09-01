package com.ssafy.lovesol.domain.user.repository;

import com.ssafy.lovesol.domain.user.entity.Notice;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
}
