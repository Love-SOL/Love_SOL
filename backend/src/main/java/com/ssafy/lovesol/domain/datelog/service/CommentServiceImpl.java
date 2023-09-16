package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.datelog.dto.request.InsertCommentRequestDto;
import com.ssafy.lovesol.domain.datelog.dto.request.UpdateCommentRequestDto;
import com.ssafy.lovesol.domain.datelog.entity.Comment;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.repository.CommentRepository;
import com.ssafy.lovesol.domain.datelog.repository.ImageRepository;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.repository.UserRepository;
import com.ssafy.lovesol.global.exception.NotExistCommentException;
import com.ssafy.lovesol.global.exception.NotExistImageException;
import com.ssafy.lovesol.global.exception.NotExistUserException;
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
    final private CommentRepository commentRepository;
    final private UserRepository userRepository;
    @Override
    @Transactional
    public void writeComment(Long imageId, InsertCommentRequestDto insertCommentRequestDto) {
        Image image = imageRepository.findById(imageId).orElseThrow(NotExistImageException::new);
        User user = userRepository.findByUserId(insertCommentRequestDto.getUserId()).orElseThrow(NotExistUserException::new);
        Comment comment = Comment.write(image, insertCommentRequestDto.getContent(), LocalDateTime.now(ZoneId.of("Asia/Seoul")), insertCommentRequestDto.getUserId(), user.getId());
        image.getCommentList().add(comment);
    }

    @Override
    @Transactional
    public void modifyComment(UpdateCommentRequestDto updateCommentRequestDto) {
        Comment comment = commentRepository.findById(updateCommentRequestDto.getCommentId()).orElseThrow(NotExistCommentException::new);
        comment.modifyContent(updateCommentRequestDto.getContent());
    }

    @Override
    public void deleteComment(Long commentId) {
        Comment comment = commentRepository.findById(commentId).orElseThrow(NotExistCommentException::new);
        commentRepository.delete(comment);
    }
}
