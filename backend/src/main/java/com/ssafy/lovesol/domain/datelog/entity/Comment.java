package com.ssafy.lovesol.domain.datelog.entity;

import com.ssafy.lovesol.domain.datelog.dto.response.CommentResponseDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long commentId;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private LocalDateTime createAt;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "image_id", nullable = false)
    private Image image;

    public static Comment write(Image image, String content, LocalDateTime createAt, Long userId, String id) {
        return Comment.builder()
                .image(image)
                .content(content)
                .createAt(createAt)
                .userId(userId)
                .id(id)
                .build();
    }

    public void modifyContent(String content) {
        this.content = content;
    }

    public CommentResponseDto toCommentResponseDto() {
        return CommentResponseDto.builder()
                .commentId(commentId)
                .content(content)
                .createAt(createAt)
                .userId(userId)
                .id(id)
                .build();
    }

}
