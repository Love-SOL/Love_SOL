package com.ssafy.lovesol.global.util;

import com.ssafy.lovesol.domain.bank.entity.Account;
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

@Component
@RequiredArgsConstructor
public class InitDb {

    private final InitService initService;

    @PostConstruct
    public void init() {
        initService.UserInit();
    }

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
                    .personalAccount("01011112222")
                    .phoneNumber("01011112222")
                    .simplePassword("123456")
                    .fcmToken("")
                    .build();

            User user2 = User.builder()
                    .id("shinhan2")
                    .password("1234")
                    .amount(0)
                    .birthAt(LocalDate.of(2000,11,11))
                    .depositAt(0)
                    .name("김신한")
                    .personalAccount("01033334444")
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
                    .commonAccount("01011112222-1")
                    .ownerTotal(0)
                    .subOwnerTotal(0)
                    .build();

            em.persist(couple);

            Account account = Account.builder()
                    .accountNumber("01011112222")
                    .balance(100000)
                    .name("박신한")
                    .userId("fc901fb0f111ae796285fb603380152500d1c1eb73107abcafb92409b49cea14")
                    .bankCode(88)
                    .type(0)
                    .build();
            Account account2 = Account.builder()
                    .accountNumber("01012341234")
                    .balance(100000)
                    .name("박신한")
                    .userId("fc901fb0f111ae796285fb603380152500d1c1eb73107abcafb92409b49cea14")
                    .bankCode(88)
                    .type(0)
                    .build();
            Account account3 = Account.builder()
                    .accountNumber("01011112222-1")
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
