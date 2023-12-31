package com.ssafy.lovesol.domain.user.entity;

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
public class Notice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long noticeId;

    @Column(nullable= false)
    private String title;
    @Column(nullable = false)
    private String body;

    @Column(nullable = false)
    private LocalDateTime createAt;

    @Column(nullable= false)
    private int kind;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_id" , nullable = false)
    private User receiver;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id" , nullable = false)
    private User sender;


}
