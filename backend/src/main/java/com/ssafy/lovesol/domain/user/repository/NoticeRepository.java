package com.ssafy.lovesol.domain.user.repository;

import com.ssafy.lovesol.domain.user.entity.Notice;
import com.ssafy.lovesol.domain.user.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    Page<Notice> findNoticesByReceiverOrderByCreateAtDesc(User keyword, Pageable page);

}
