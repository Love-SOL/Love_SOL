package com.ssafy.lovesol.domain.datelog.repository;


import com.ssafy.lovesol.domain.datelog.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentRepository extends JpaRepository<Comment,Long> {
}
