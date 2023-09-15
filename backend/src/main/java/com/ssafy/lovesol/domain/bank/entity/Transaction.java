package com.ssafy.lovesol.domain.bank.entity;

import com.ssafy.lovesol.domain.bank.dto.response.GetTransactionResponseDto;
import com.ssafy.lovesol.domain.user.entity.User;
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
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long transactionId;

    @Column(nullable = false)
    private LocalDateTime transactionAt;

    @Column(nullable = false)
    private double withdrawalAmount;

    @Column(nullable = false)
    private double depositAmount;

    // 출금 : 0 , 입금 : 1
    @Column(nullable = false)
    private int transactionType;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private String branchName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_number" , nullable = false)
    private Account account;

    public static Transaction createTransaction(Account account , String content , String branchName , int depositAmount , int withdrawalAmount){
        return Transaction.builder()
                .transactionAt(LocalDateTime.now())
                .account(account)
                .content(content)
                .branchName(branchName)
                .depositAmount(depositAmount)
                .withdrawalAmount(withdrawalAmount)
                .transactionType(1)
                .build();
    }

    public GetTransactionResponseDto toGetTransactionResponseDto(){
        return GetTransactionResponseDto.builder()
            .content(content)
            .transactionType(transactionType)
            .transactionAmount((int)(transactionType == 0 ? withdrawalAmount : depositAmount))
            .transactionAt(transactionAt)
            .build();
    }
}
