package com.ssafy.lovesol.domain.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponseDto {


    private String id;

    private String personalAccount;

    private String name;

    private String phoneNumber;

    private LocalDate birthAt;

    private int amount;

    private int depositAt;


}
