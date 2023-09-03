package com.ssafy.lovesol.domain.schedule.entity;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.schedule.dto.request.UpdateScheduleRequestDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Schedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long scheduleId;

    @Column(nullable = false)
    private LocalDateTime startAt;

    @Column(nullable = false)
    private LocalDateTime endAt;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private ScheduleType scheduleType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "couple_id", nullable = false)
    private Couple couple;

    public void updateSchedule(UpdateScheduleRequestDto updateScheduleRequestDto, ScheduleType scheduleType){
        this.content = updateScheduleRequestDto.getContent();
        this.startAt = updateScheduleRequestDto.getStartAt();
        this.endAt = updateScheduleRequestDto.getEndAt();
        this.scheduleType = scheduleType;
    }
}
