package com.ssafy.lovesol.domain.bank.entity;


import com.ssafy.lovesol.domain.bank.dto.response.GetUserAccountsResponseDto;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Builder
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Account {

    @Id
    private String accountNumber;

    @Column(nullable = false)
    private String userId;

    @Column(nullable = false)
    private int bankCode;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private double balance;

    @Column(nullable = false)
    private int type;

    @OneToMany(mappedBy = "account" , cascade = CascadeType.ALL)
    private List<Transaction> transactionList;

    public GetUserAccountsResponseDto toGetUserAccountsResponseDto(){
        return GetUserAccountsResponseDto.builder()
                .accountNumber(accountNumber)
                .name(name)
                .type(type)
                .balance(balance)
                .build();
    }
}
