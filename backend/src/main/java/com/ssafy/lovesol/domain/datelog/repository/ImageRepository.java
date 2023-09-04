package com.ssafy.lovesol.domain.datelog.repository;

import com.ssafy.lovesol.domain.datelog.entity.Image;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ImageRepository extends JpaRepository<Image,Long> {
}
