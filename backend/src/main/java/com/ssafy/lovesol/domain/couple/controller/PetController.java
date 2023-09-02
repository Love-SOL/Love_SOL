package com.ssafy.lovesol.domain.couple.controller;

import com.ssafy.lovesol.domain.couple.entity.Pet;
import com.ssafy.lovesol.global.response.ResponseResult;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@ApiResponses({
        @ApiResponse(responseCode = "200", description = "응답이 성공적으로 반환되었습니다."),
        @ApiResponse(responseCode = "400", description = "응답이 실패하였습니다.",
                content = @Content(schema = @Schema(implementation = ResponseResult.class)))})
@Tag(name = "Pet Controller", description = "펫 컨트롤러")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/pet")
public class PetController {
    @GetMapping("/{coupleId}")
    public ResponseResult getPet(@PathVariable String coupleId) throws Exception {
        log.info(coupleId + "의 펫 정보를 불러옵니다.");

        return ResponseResult.failResponse;
    }

    @PostMapping("/{coupleId}")
    public ResponseResult createPet(@PathVariable String coupleId, @Valid @RequestBody Pet petDto) throws Exception {
        log.info(coupleId + "의 펫을 생성합니다.");

        return ResponseResult.failResponse;
    }

    @PutMapping("/{coupleId}")
    public ResponseResult modifyPet(@PathVariable String coupleId, @Valid @RequestBody int exp) throws  Exception {
        log.info(coupleId + "의 펫에게 " + exp + "만큼의 경험치를 부여합니다.");

        return ResponseResult.failResponse;
    }

    @DeleteMapping("/{coupleId}")
    public ResponseResult removePet(@PathVariable String coupleId) throws  Exception {
        log.info(coupleId + "의 펫을 삭제합니다.");

        return ResponseResult.failResponse;
    }
}
