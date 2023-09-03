package com.ssafy.lovesol.domain.schedule.entity;

import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.schedule.dto.request.UpdateScheduleRequestDto;
import com.ssafy.lovesol.domain.schedule.dto.response.ScheduleResponseDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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
    private LocalDate startAt;

    @Column(nullable = false)
    private LocalDate endAt;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private ScheduleType scheduleType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "couple_id", nullable = false)
    private Couple couple;

    public void updateSchedule(UpdateScheduleRequestDto updateScheduleRequestDto, ScheduleType scheduleType){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        LocalDate updatedStartAt = LocalDate.parse(updateScheduleRequestDto.getStartAt(), formatter);
        LocalDate updatedEndAt = LocalDate.parse(updateScheduleRequestDto.getEndAt(), formatter);

        this.content = updateScheduleRequestDto.getContent();
        this.startAt = updatedStartAt;
        this.endAt = updatedEndAt;
        this.scheduleType = scheduleType;
    }

    public ScheduleResponseDto toScheduleResponseDto(){
        return ScheduleResponseDto.builder()
                .scheduleId(scheduleId)
                .content(content)
                .startAt(startAt)
                .endAt(endAt)
                .scheduleType(scheduleType)
                .build();
    }
}
