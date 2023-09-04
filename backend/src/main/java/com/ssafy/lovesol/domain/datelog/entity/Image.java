package com.ssafy.lovesol.domain.datelog.entity;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.datelog.dto.response.ImageResponseDto;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Image{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long imageId;

    @Column(nullable = false)
    private String imgUrl;

    @Column(nullable = false)
    private LocalDateTime createAt;

    @Column(nullable = false)
    private String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "date_log_id", nullable = false)
    private DateLog dateLog;

    @OneToMany(mappedBy = "image", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> commentList = new ArrayList<>();

    public void updateImageUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public void updateContent(String content) {
        this.content = content;
    }

    public static Image create(DateLog dateLog, String imgUrl, String content, LocalDateTime createAt){
        return Image.builder()
                .dateLog(dateLog)
                .imgUrl(imgUrl)
                .content(content)
                .createAt(createAt)
                .build();
    }

    public ImageResponseDto toImageResponseDto() {
        return ImageResponseDto.builder()
                .imageId(imageId)
                .imgUrl(imgUrl)
                .content(content)
                .createAt(createAt)
                .build();
    }
}


