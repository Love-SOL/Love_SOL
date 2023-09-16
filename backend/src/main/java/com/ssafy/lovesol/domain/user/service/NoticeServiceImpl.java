package com.ssafy.lovesol.domain.user.service;

import com.ssafy.lovesol.domain.user.dto.response.NoticeResDto;
import com.ssafy.lovesol.domain.user.entity.Notice;
import com.ssafy.lovesol.domain.user.entity.User;
import com.ssafy.lovesol.domain.user.repository.NoticeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Slf4j
@RequiredArgsConstructor
@Service
public class NoticeServiceImpl implements NoticeService{
    private final int PAGE_NUM = 8;

    private final NoticeRepository noticeRepository;
    @Override
    public void registNotice(User sender, User receiver, String title, String body, int kind) {
        noticeRepository.save(Notice.builder()
                        .sender(sender)
                        .receiver(receiver)
                        .title(title)
                        .body(body)
                        .kind(kind)
                        .createAt(LocalDateTime.now())
                .build());
    }

    @Override
    public Page<NoticeResDto> getNoticeList(User receiver, int page) {
        String[] kinds = {"기타","펫","데이트로그","일정","커뮤니티"};
        return noticeRepository.findNoticesByReceiverOrderByCreateAtDesc
                (receiver, PageRequest.of(page,PAGE_NUM)).map(
                Notices ->
                        NoticeResDto.builder()
                                .body(Notices.getBody())
                                .SenderName(Notices.getSender().getName())
                                .title(Notices.getTitle())
                                .createAt(Notices.getCreateAt())
                                .kind(kinds[Notices.getKind()>4?0:Notices.getKind()])
                                .build()
        );
    }
}
