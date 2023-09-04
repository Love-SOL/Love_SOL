package com.ssafy.lovesol.domain.datelog.controller;

import com.ssafy.lovesol.domain.datelog.dto.request.InsertCommentRequestDto;
import com.ssafy.lovesol.domain.datelog.entity.Comment;
import com.ssafy.lovesol.domain.datelog.service.CommentService;
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
@Tag(name = "Comment Controller", description = "댓글 컨트롤러")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/comment")
public class CommentController {
    final private CommentService commentService;
    /**
     * 해당 이미지에 댓글을 작성한다.
     * @param imageId
     * @param insertCommentRequestDto
     * @return
     * @throws Exception
     */
    @PostMapping("/{imageId}")
    public ResponseResult writeComment(@PathVariable Long imageId, @Valid @RequestBody InsertCommentRequestDto insertCommentRequestDto) throws Exception {
        commentService.writeComment(imageId, insertCommentRequestDto);
        return ResponseResult.successResponse;
    }

    /**
     * 해당 댓글을 수정한다.
     * @param commentId
     * @param comment
     * @return
     * @throws Exception
     */
    @PutMapping("/{commentId}")
    public ResponseResult modifyComment(@PathVariable String commentId, @Valid @RequestBody Comment comment) throws Exception {
        // TODO: 해당 댓글이 존재하는지 검사한다.

        // TODO: 댓글을 수정한다.
        return ResponseResult.failResponse;
    }

    /**
     * 해당 댓글을 삭제한다.
     * @param commentId
     * @param comment
     * @return
     * @throws Exception
     */
    @DeleteMapping("/{commentId}")
    public ResponseResult removeComment(@PathVariable String commentId, @Valid @RequestBody Comment comment) throws  Exception {
        // TODO: 해당 댓글이 존재하는지 검사한다.

        // TODO: 댓글을 삭제한다.
        return ResponseResult.failResponse;
    }
}
