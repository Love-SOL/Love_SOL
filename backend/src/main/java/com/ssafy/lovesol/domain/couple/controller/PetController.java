package com.ssafy.lovesol.domain.couple.controller;

import com.ssafy.lovesol.domain.couple.dto.request.CreatePetRequestDto;
import com.ssafy.lovesol.domain.couple.dto.request.IncreasePetExpRequestDto;
import com.ssafy.lovesol.domain.couple.dto.response.ResponsePetDto;
import com.ssafy.lovesol.domain.couple.entity.Pet;
import com.ssafy.lovesol.domain.couple.service.PetService;
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

import java.net.http.HttpResponse;

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
    private final PetService petService;
    @GetMapping("/{coupleId}")
    public ResponseResult getPet(@PathVariable String coupleId) throws Exception {
        log.info(coupleId + "의 펫 정보를 불러옵니다.");
        return new SingleResponseResult<ResponsePetDto>(petService.getPet(Long.parseLong(coupleId)));
    }

    @PostMapping("/{coupleId}")
    public ResponseResult createPet(@PathVariable String coupleId, @Valid @RequestBody CreatePetRequestDto pet) throws Exception {
        log.info(coupleId + "의 펫을 생성합니다.");
        // pet 객체에 펫 이름과 커플 객체 넣어서 생성
        ResponsePetDto responsePetDto = petService.createPet(pet.getName(), pet.getKind(), Long.parseLong(coupleId));
        return new SingleResponseResult<ResponsePetDto>(responsePetDto);
    }

    @PutMapping("/{coupleId}")
    public ResponseResult increasePetExp(@PathVariable Long coupleId, @Valid @RequestBody IncreasePetExpRequestDto increasePetExpRequestDto) throws  Exception {
        log.info(coupleId + "의 펫에게 " + increasePetExpRequestDto.getExp() + "만큼의 경험치를 부여합니다.");
        petService.gainExp(coupleId, increasePetExpRequestDto.getExp());
        return ResponseResult.successResponse;
    }
}
