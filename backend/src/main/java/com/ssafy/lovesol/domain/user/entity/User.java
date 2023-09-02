package com.ssafy.lovesol.domain.user.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Column(nullable = false)
    private String id;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String simplePassword;

    @Column(nullable = false)
    private String personalAccount;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String phoneNumber;

    @Column(nullable = false)
    private String birthAt;

    @Column(nullable =true)
    private int amount;

    @Column(nullable =true)
    private int depositAt;

    // 어떤 User가 여러 개의 알람을 "받을 수" 있는 경우
    @OneToMany(mappedBy = "receiver" , cascade = CascadeType.ALL)
    private List<Notice> receiveNoticeList;

    // 어떤 User가 여러 개의 알람을 "보낼 수" 있는 경우
    @OneToMany(mappedBy = "sender" , cascade = CascadeType.ALL)
    private List<Notice> sendNoticeList;

}
