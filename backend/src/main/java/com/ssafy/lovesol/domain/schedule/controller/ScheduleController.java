package com.ssafy.lovesol.domain.schedule.controller;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.couple.service.CoupleService;
import com.ssafy.lovesol.domain.schedule.dto.request.CreateScheduleRequestDto;
import com.ssafy.lovesol.domain.schedule.dto.request.UpdateScheduleRequestDto;
import com.ssafy.lovesol.domain.schedule.service.ScheduleService;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.service.NoticeService;
import com.ssafy.lovesol.domain.user.service.UserService;
import com.ssafy.lovesol.global.fcm.Service.FCMNotificationService;
import com.ssafy.lovesol.global.fcm.dto.request.FcmRequestDto;
import com.ssafy.lovesol.global.response.ListResponseResult;
import com.ssafy.lovesol.global.response.ResponseResult;
import com.ssafy.lovesol.global.response.SingleResponseResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@ApiResponses({
        @ApiResponse(responseCode = "200", description = "응답이 성공적으로 반환되었습니다."),
        @ApiResponse(responseCode = "400", description = "응답이 실패하였습니다.",
                content = @Content(schema = @Schema(implementation = ResponseResult.class)))})
@Tag(name = "Schedule Controller", description = "일정 컨트롤러")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/schedule")
public class ScheduleController {
    private final CoupleService coupleService;
    private final UserService userService;
    private final FCMNotificationService fcmNotificationService;
    private final NoticeService noticeService;
    private final ScheduleService scheduleService;

    @Operation(summary = "Create Schedule", description = "일정등록 하기")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "일정등록 성공"),
            @ApiResponse(responseCode = "400", description = "일정등록 실패")
    })
    @PostMapping("/{coupleId}")
    public ResponseResult CreateSchedule(@PathVariable(value = "coupleId") Long coupleId,
                                         @Valid @RequestBody CreateScheduleRequestDto createScheduleRequestDto , HttpServletRequest request) {
        log.info("UserController_CreateSchedule | 일정 등록");
        if(scheduleService.createSchedule(coupleId , createScheduleRequestDto , request) >= 0) {
            String title = "일정 등록";
            String body = "상대방이 일정을 추가하였어요";
            Couple couple = coupleService.getCoupleInfoByCouplId(coupleId);
            int kind = 2;

            User sender = couple.getOwner();
            User receiver = couple.getSubOwner();
            noticeService.registNotice(sender,receiver,title,body,kind);
            noticeService.registNotice(receiver,sender,title,body,kind);
            if(!fcmNotificationService.sendNotificationByToken(FcmRequestDto.builder().targetId(sender.getUserId()).title(title).body(body).build())||!fcmNotificationService.sendNotificationByToken(FcmRequestDto.builder().targetId(receiver.getUserId()).title(title).body(body).build()))
            { return ResponseResult.failResponse;}
            return ResponseResult.successResponse;
        }
        return ResponseResult.failResponse;
    }

    @Operation(summary = "Update Schedule", description = "일정 수정 하기")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "일정 수정 성공"),
            @ApiResponse(responseCode = "400", description = "일정 수정 실패")
    })
    @PutMapping("/{coupleId}")
    public ResponseResult UpdateSchedule(@PathVariable(value = "coupleId") Long coupleId,
                                         @Valid @RequestBody UpdateScheduleRequestDto updateScheduleRequestDto , HttpServletRequest request) {
        log.info("UserController_UpdateSchedule | 일정 수정");
        scheduleService.updateSchedule(coupleId , updateScheduleRequestDto , request);
        return ResponseResult.successResponse;
    }

    @Operation(summary = "Delete Schedule", description = "일정 삭제 하기")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "일정 삭제 성공"),
            @ApiResponse(responseCode = "400", description = "일정 삭제 실패")
    })
    @DeleteMapping("/{scheduleId}")
    public ResponseResult DeleteSchedule(@PathVariable(value = "scheduleId") Long scheduleId) {
        log.info("UserController_DeleteSchedule | 일정 삭제");
        scheduleService.deleteSchedule(scheduleId);
        return ResponseResult.successResponse;
    }

    @Operation(summary = "Get All Schedule", description = "전체 일정 조회 하기")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "전체 일정 조회 성공"),
            @ApiResponse(responseCode = "400", description = "전체 일정 조회 실패")
    })
    @GetMapping("/{coupleId}")
    public ResponseResult getAllScheduleByYearAndMonth(
            @PathVariable(value = "coupleId") Long coupleId , @RequestParam(value = "year") int year , @RequestParam(value = "month") int month) {
        log.info("UserController_getAllScheduleByYearAndMonth | 전체 일정 조회");
        return new SingleResponseResult<>(scheduleService.getAllScheduleByYearAndMonth(coupleId, year, month));
    }

    @Operation(summary = "Get Date Schedule", description = "특정 날짜 일정 조회 하기")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "특정 날짜 일정 조회 성공"),
            @ApiResponse(responseCode = "400", description = "특정 날짜 일정 조회 실패")
    })
    @GetMapping("/{coupleId}/{dateAt}")
    public ResponseResult getScheduleByDate(
            @PathVariable(value = "coupleId") Long coupleId , @PathVariable(value = "dateAt") String dateAt) {
        log.info("UserController_getScheduleByDate | 특정 날짜 일정 조회");
        return new ListResponseResult<>(scheduleService.getScheduleByDate(coupleId, LocalDate.parse(dateAt)));
    }

    @Operation(summary = "Get Recent Couple Schedule", description = "가장 가까운 커플 일정 조회")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "가장 가까운 커플 일정 조회 성공"),
            @ApiResponse(responseCode = "400", description = "가장 가까운 커플 일정 조회 실패")
    })
    @GetMapping("/recent/{coupleId}")
    public ResponseResult getRecentCoupleSchedule(
            @PathVariable(value = "coupleId") Long coupleId) {
        log.info("UserController_getRecentCoupleSchedule");
        return new SingleResponseResult<>(scheduleService.getRecentCoupleSchedule(coupleId));
    }


}
