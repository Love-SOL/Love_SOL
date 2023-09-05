package com.ssafy.lovesol.domain.bank.entity;


import com.ssafy.lovesol.domain.user.entity.Notice;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Account {

    @Id
    private String accountNumber;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private int bankCode;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private double balance;

    @OneToMany(mappedBy = "account" , cascade = CascadeType.ALL)
    private List<Transaction> transactionList;
}
