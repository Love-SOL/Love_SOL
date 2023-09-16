package com.ssafy.lovesol.global.util;

import com.ssafy.lovesol.domain.bank.entity.Account;
import com.ssafy.lovesol.domain.bank.entity.Transaction;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.entity.Pet;
import com.ssafy.lovesol.domain.user.entity.Notice;
import com.ssafy.lovesol.domain.user.entity.User;
import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Component
@RequiredArgsConstructor
public class InitDb {

    private final InitService initService;

    // @PostConstruct
    // public void init() {
    //     initService.UserInit();
    // }

    @Component
    @Transactional
    @RequiredArgsConstructor
    static class InitService {

        private final EntityManager em;

        public void UserInit() {
            User user1 = User.builder()
                .id("shinhan")
                .password("1234")
                .amount(0)
                .birthAt(LocalDate.of(2000,01,01))
                .depositAt(0)
                .name("박신한")
                .personalAccount("110556128939")
                .phoneNumber("01011112222")
                .simplePassword("123456")
                .fcmToken("")
                .build();

            User user2 = User.builder()
                .id("shinhan2")
                .password("1234")
                .amount(0)
                .birthAt(LocalDate.of(2002,11,11))
                .depositAt(0)
                .name("김신한")
                .personalAccount("000111222333")
                .phoneNumber("01033334444")
                .simplePassword("123456")
                .fcmToken("")
                .build();

            em.persist(user1);
            em.persist(user2);

            Couple couple = Couple.builder()
                .owner(user1)
                .subOwner(user2)
                .anniversary(LocalDate.now().minusYears(1))
                .commonAccount("110556128939-1")
                .ownerTotal(0)
                .subOwnerTotal(0)
                .build();

            em.persist(couple);

            Account account = Account.builder()
                .accountNumber("110556128939")
                .balance(100000)
                .name("박신한")
                .userId("c1aa4bf6a27dfe51995d6044e9363e5b07b2c218e662362fbfaee6b271c117dd")
                .bankCode(88)
                .type(0)
                .build();

            Account account2 = Account.builder()
                .accountNumber("110556128939-1")
                .balance(100000)
                .name("박신한")
                .userId("c1aa4bf6a27dfe51995d6044e9363e5b07b2c218e662362fbfaee6b271c117dd")
                .bankCode(88)
                .type(1)
                .build();

            Account account3 = Account.builder()
                .accountNumber("000111222333")
                .balance(100000)
                .name("김신한")
                .userId("a7c7664734060856bf6b826e2f4c78f8bfa4a0cd123354d4bdb27952c7922e1b")
                .bankCode(88)
                .type(0)
                .build();

            em.persist(account);
            em.persist(account2);
            em.persist(account3);

        }
    }
}

