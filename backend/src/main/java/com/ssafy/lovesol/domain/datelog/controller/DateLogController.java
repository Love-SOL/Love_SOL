package com.ssafy.lovesol.domain.datelog.controller;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.datelog.dto.request.InsertImageDto;
import com.ssafy.lovesol.domain.datelog.dto.request.UpdateImageDto;
import com.ssafy.lovesol.domain.datelog.dto.response.DateLogResponseDto;
import com.ssafy.lovesol.domain.datelog.dto.response.ImageResponseDto;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.service.DateLogService;
import com.ssafy.lovesol.domain.datelog.service.ImageService;
import com.ssafy.lovesol.domain.user.entity.User;
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
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@ApiResponses({
        @ApiResponse(responseCode = "200", description = "응답이 성공적으로 반환되었습니다."),
        @ApiResponse(responseCode = "400", description = "응답이 실패하였습니다.",
                content = @Content(schema = @Schema(implementation = ResponseResult.class)))})
@Tag(name = "DateLog Controller", description = "DateLog 컨트롤러")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/date-log")
public class DateLogController {
    final private DateLogService dateLogService;
    final private ImageService imageService;

    private final FCMNotificationService fcmNotificationService;
    /**
     * 데이트 일기를 생성하는 API
     * 해당 날짜의 데이트 일기를 생성한다.
     * @param coupleId
     * @param dateAt
     * @return
     * @throws Exception
     */
    @GetMapping("/{coupleId}/{dateAt}")
    public ResponseResult createDateLog(@PathVariable String coupleId, @PathVariable String dateAt) throws Exception {
        log.info(coupleId + "의 데이트 일기를 생성합니다.");
        if (dateLogService.createDateLog(Long.parseLong(coupleId), LocalDate.parse(dateAt)) >= 0){
            return ResponseResult.successResponse;
        }
        return ResponseResult.failResponse;
    }

    /**
     * 해당 데이트 일기 내에 존재하는 이미지 객체들을 조회한다.
     * @param dateLogId
     * @return
     * @throws Exception
     */
    @GetMapping("/{dateLogId}")
    public ResponseResult getDateLog(@PathVariable Long dateLogId) throws Exception {
        log.info(dateLogId + " 데이트 일기를 조회합니다.");
        return new SingleResponseResult<DateLogResponseDto>(dateLogService.getDateLog(dateLogId));
    }

  

    /**
     * 해당 데이트 일기에 이미지를 첨부한다.
     * 이미지 객체에는 이미지 URL과 이미지의 텍스트 내용이 존재한다.
     * @param dateLogId
     * @param image
     * @return
     */
    @PostMapping("/{dateLogId}")
    public ResponseResult registImage(@PathVariable String dateLogId, @Valid @RequestParam MultipartFile image, @Valid @RequestParam String content) throws Exception {
        log.info(dateLogId + " 데이트 일기에 이미지를 삽입합니다.");
        // 데이트 로그에 이미지를 삽입한다.
        dateLogService.insertImage(Long.parseLong(dateLogId), image, content);
        // TODO: 일기 작성 알림을 보낸다.
        //여기서 커플 객채를 만들어줘야한다.
        String titleInit= "일기가 작성됐어요";
        String bodyInit= "지금 바로 확인해보세요!";
        log.info("DateLogService -> 이미지 삽입 fcm 전송");
        Couple couple = dateLogService.getDatelogCouple(Long.parseLong(dateLogId));
        User owner = couple.getOwner();
        User subOwner = couple.getSubOwner();
        Map<String, String> data = new HashMap<>();
        data.put("kind", "1");
        fcmNotificationService.sendNotificationByToken(FcmRequestDto.builder().targetId(owner.getUserId()).title(titleInit).body(bodyInit).build(), data);
        fcmNotificationService.sendNotificationByToken(FcmRequestDto.builder().targetId(subOwner.getUserId()).title(titleInit).body(bodyInit).build(), data);
        return ResponseResult.successResponse;
    }

    /**
     * 해당 이미지의 상세 정보를 조회한다.
     * 날짜, 이미지, 내용, 작성된 모든 댓글을 조회한다.
     * @param imageId
     * @return
     * @throws Exception
     */
    @GetMapping("/image/{imageId}")
    public  ResponseResult getImageDetail(@PathVariable String imageId) throws Exception {
        log.info(imageId + " 이미지를 상세 조회합니다.");
        // 이미지 객체 정보를 조회한다.
        return new SingleResponseResult<Image>(imageService.getImage(Long.parseLong(imageId)));
    }

    @GetMapping("/image/all/{coupleId}")
    public ResponseResult getImageALL(@PathVariable Long coupleId) throws Exception {
        log.info(coupleId + " 커플 전체 이미지를 조회합니다.");
        return new SingleResponseResult<List<ImageResponseDto>>(dateLogService.getAllImage(coupleId));
    }

    /**
     * 해당 이미지 내용을 수정한다.
     * 이미지 혹은 이미지 내용을 수정할 수 있다.
     * @param imageId
     * @param image
     * @return
     * @throws Exception
     */
    @PutMapping("/image/{imageId}")
    public ResponseResult modifyImage(@PathVariable Long imageId, @Valid @RequestParam MultipartFile image, @Valid @RequestParam String content) throws Exception {
        log.info(imageId + " 이미지를 수정합니다.");
        // 이미지 객체를 수정한다.
        imageService.updateImage(imageId, image, content);
        // TODO: 이미지 수정 알림을 보낸다.
        return ResponseResult.successResponse;
    }

    /**
     * 이미지를 삭제합니다.
     * @param imageId
     * @return
     * @throws Exception
     */
    @DeleteMapping("/image/{imageId}")
    public ResponseResult removeImage(@PathVariable String imageId) throws Exception {
        log.info(imageId + " 이미지를 삭제합니다.");
        // 이미지 객체를 삭제한다.
        imageService.deleteImage(Long.parseLong(imageId));
        return ResponseResult.successResponse;
    }

    @Operation(summary = "Get DateLog", description = "캘린더 조회시 데이트 로그 조회")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "캘린더 조회시 데이트 로그 조회 성공"),
        @ApiResponse(responseCode = "400", description = "캘린더 조회시 데이트 로그 조회 실패")
    })
    @GetMapping("/calendar/{coupleId}")
    public ResponseResult getDateLogList(
        @PathVariable(value = "coupleId") Long coupleId , @RequestParam(value = "year") int year , @RequestParam(value = "month") int month) {
        log.info("UserController_getDateLogList");
        return new ListResponseResult<>(dateLogService.getDateLogList(coupleId,year,month));
    }
}
