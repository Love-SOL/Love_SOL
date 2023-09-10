package com.ssafy.lovesol.domain.user.entity;

import com.ssafy.lovesol.domain.user.dto.response.LoginResponseDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.extern.java.Log;
import org.hibernate.annotations.ColumnDefault;

import java.time.LocalDate;
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
    private LocalDate birthAt;

    @Column(nullable =true)
    private int amount;

    @Column(nullable =true)
    private int depositAt;

    @Column(nullable = false)
    @ColumnDefault(value = "''")
    private String fcmToken;

    // 어떤 User가 여러 개의 알람을 "받을 수" 있는 경우
    @OneToMany(mappedBy = "receiver" , cascade = CascadeType.ALL)
    private List<Notice> receiveNoticeList;

    // 어떤 User가 여러 개의 알람을 "보낼 수" 있는 경우
    @OneToMany(mappedBy = "sender" , cascade = CascadeType.ALL)
    private List<Notice> sendNoticeList;


    public void setAutoDeposit(int depositAt, int amount){
        this.amount = amount;
        this.depositAt = depositAt;
    }

    public void setFcmToken(String token){
        this.fcmToken = token;
    }
    public LoginResponseDto toLoginResponseDto(Long coupleId){
        return LoginResponseDto.builder()
                .userId(userId)
                .coupleId(coupleId)
                .build();
    }

    public void setSimplePassword(String simplePassword){
        this.simplePassword = simplePassword;
    }
}
