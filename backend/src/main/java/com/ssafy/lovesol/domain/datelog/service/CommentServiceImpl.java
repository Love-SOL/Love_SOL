package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.datelog.dto.request.InsertCommentRequestDto;
import com.ssafy.lovesol.domain.datelog.entity.Comment;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.repository.ImageRepository;
import com.ssafy.lovesol.global.exception.NotExistImageException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;

@Slf4j
@RequiredArgsConstructor
@Service
public class CommentServiceImpl implements CommentService{
    final private ImageRepository imageRepository;
    @Override
    @Transactional
    public void writeComment(Long imageId, InsertCommentRequestDto insertCommentRequestDto) {
        Image image = imageRepository.findById(imageId).orElseThrow(NotExistImageException::new);
        Comment comment = Comment.write(image, insertCommentRequestDto.getContent(), LocalDateTime.now(ZoneId.of("Asia/Seoul")));
        image.getCommentList().add(comment);
    }
}
