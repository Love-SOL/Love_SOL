package com.ssafy.lovesol.domain.user.service;

import com.ssafy.lovesol.domain.user.dto.response.NoticeResDto;
import com.ssafy.lovesol.domain.user.entity.Notice;
import com.ssafy.lovesol.domain.user.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface NoticeService {
    void registNotice(User senderId, User receiver, String title, String body, int kind );

    Page<NoticeResDto> getNoticeList(User receiver, int page);
}
