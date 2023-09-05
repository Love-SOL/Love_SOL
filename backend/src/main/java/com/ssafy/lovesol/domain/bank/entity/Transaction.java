package com.ssafy.lovesol.domain.bank.entity;

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
    private double WithdrawalAmount;

    @Column(nullable = false)
    private double DepositAmount;

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
                .DepositAmount(depositAmount)
                .WithdrawalAmount(withdrawalAmount)
                .build();

    }
}
