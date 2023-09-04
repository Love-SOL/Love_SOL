package com.ssafy.lovesol.global.util;

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

//    @PostConstruct
//    public void init() {
//        initService.UserInit();
//    }

    @Component
    @Transactional
    @RequiredArgsConstructor
    static class InitService {

        private final EntityManager em;

        public void UserInit() {
            User user1 = User.builder()
                    .id("ssafy")
                    .password("1234")
                    .amount(0)
                    .birthAt(LocalDate.of(2000,01,01))
                    .depositAt(0)
                    .name("박싸피")
                    .personalAccount("111222333")
                    .phoneNumber("01011112222")
                    .simplePassword("123456")
                    .build();

            User user2 = User.builder()
                    .id("ssafy2")
                    .password("1234")
                    .amount(0)
                    .birthAt(LocalDate.of(2000,11,11))
                    .depositAt(0)
                    .name("김싸피")
                    .personalAccount("123123123")
                    .phoneNumber("01033334444")
                    .simplePassword("123456")
                    .build();

            em.persist(user1);
            em.persist(user2);

            Couple couple = Couple.builder()
                    .owner(user1)
                    .subOwner(user2)
                    .anniversary(LocalDate.now().minusYears(1))
                    .commonAccount("135135135")
                    .ownerTotal(0)
                    .subOwnerTotal(0)
                    .build();

            em.persist(couple);

        }


    }
}
