package com.ssafy.lovesol.domain.user.controller;

import com.ssafy.lovesol.domain.user.dto.response.NoticeResDto;
import com.ssafy.lovesol.domain.user.entity.Notice;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.NoticeService;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.response.ListResponseResult;
import com.ssafy.lovesol.global.response.ResponseResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@ApiResponses({
        @ApiResponse(responseCode = "200", description = "응답이 성공적으로 반환되었습니다."),
        @ApiResponse(responseCode = "400", description = "응답이 실패하였습니다.",
                content = @Content(schema = @Schema(implementation = ResponseResult.class)))})
@Tag(name = "Notice Controller", description = "알람 컨트롤러")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/notice")
public class NoticeController {
    private final NoticeService noteNoticeService;
    private final UserService userService;
    @Operation(summary = "알림 조회", description = "사용자에게 들어온 알림을 모두 출력한다")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Push 알람 발송 성공")
    })
    @PostMapping("/{userId}")
    public ListResponseResult<NoticeResDto> getListNotice(@PathVariable long userId){
        User user = userService.getUserByUserId(userId);
        return new ListResponseResult<>(noteNoticeService.getNoticeList(user,0).getContent());
    }
}
