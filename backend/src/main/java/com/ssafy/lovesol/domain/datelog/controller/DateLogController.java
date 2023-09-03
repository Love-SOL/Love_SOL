package com.ssafy.lovesol.domain.datelog.controller;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.datelog.dto.request.UpdateImageDto;
import com.ssafy.lovesol.domain.datelog.entity.DateLog;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.service.DateLogService;
import com.ssafy.lovesol.domain.datelog.service.ImageService;
import com.ssafy.lovesol.global.response.ResponseResult;
import com.ssafy.lovesol.global.response.SingleResponseResult;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
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
    DateLogService dateLogService;
    ImageService imageService;
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
        if (dateLogService.createDateLog(Long.parseLong(coupleId), LocalDateTime.parse(dateAt)) >= 0){
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
    public ResponseResult getDateLog(@PathVariable String dateLogId) throws Exception {
        log.info(dateLogId + " 데이트 기록을 조회합니다.");
        return new SingleResponseResult<DateLog>(dateLogService.getDateLog(Long.parseLong(dateLogId)));
    }

    /**
     * 해당 데이트 일기에 이미지를 첨부한다.
     * 이미지 객체에는 이미지 URL과 이미지의 텍스트 내용이 존재한다.
     * @param dateLogId
     * @param image
     * @return
     */
    @PostMapping("/{dateLogId}")
    public ResponseResult registImage(@PathVariable String dateLogId, @Valid @RequestBody Image image) throws Exception {
        log.info(dateLogId + " 데이트 로그에 이미지를 삽입합니다.");
        // 데이트 로그에 이미지를 삽입한다.
        dateLogService.insertImage(Long.parseLong(dateLogId), image);
        // TODO: 일기 작성 알림을 보낸다.

        return ResponseResult.successResponse;
    }

    /**
     * 해당 이미지의 상세 정보를 조회한다.
     * 날짜, 이미지, 내용, 작성된 모든 댓글을 조회한다.
     * @param imageId
     * @return
     * @throws Exception
     */
    @GetMapping("/{imageId}")
    public  ResponseResult getImageDetail(@PathVariable String imageId) throws Exception {
        // 이미지 객체 정보를 조회한다.
        return new SingleResponseResult<Image>(imageService.getImage(Long.parseLong(imageId)));
    }

    /**
     * 해당 이미지 내용을 수정한다.
     * 이미지 혹은 이미지 내용을 수정할 수 있다.
     * @param imageId
     * @param updateImage
     * @return
     * @throws Exception
     */
    @PutMapping("/{imageId}")
    public ResponseResult modifyImage(@PathVariable String imageId, @Valid @RequestBody UpdateImageDto updateImage) throws Exception {
        // 이미지 객체를 수정한다.
        imageService.updateImage(updateImage);
        // TODO: 이미지 수정 알림을 보낸다.
        return ResponseResult.failResponse;
    }

    @DeleteMapping("/{imageId}")
    public ResponseResult removeImage(@PathVariable String imageId) throws Exception {
        // 이미지 객체를 삭제한다.
        imageService.deleteImage(Long.parseLong(imageId));
        return ResponseResult.successResponse;
    }
}
