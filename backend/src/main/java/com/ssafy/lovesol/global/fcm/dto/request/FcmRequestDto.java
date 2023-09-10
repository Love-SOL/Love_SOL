package com.ssafy.lovesol.global.fcm.dto.request;

import lombok.*;

@Getter
@Setter
@RequiredArgsConstructor
public class FcmRequestDto {
    private Long targetId;
    private String title;
    private String body;

}
