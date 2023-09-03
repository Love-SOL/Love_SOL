package com.ssafy.lovesol.domain.schedule.controller;

import com.ssafy.lovesol.domain.schedule.dto.request.CreateScheduleRequestDto;
import com.ssafy.lovesol.domain.schedule.dto.request.UpdateScheduleRequestDto;
import com.ssafy.lovesol.domain.schedule.service.ScheduleService;
import com.ssafy.lovesol.global.response.ResponseResult;
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
        if(scheduleService.createSchedule(coupleId , createScheduleRequestDto , request) >= 0)
            return ResponseResult.successResponse;
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


}
