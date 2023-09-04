package com.ssafy.lovesol.domain.datelog.entity;

import com.ssafy.lovesol.domain.couple.dto.response.ResponsePetDto;
import com.ssafy.lovesol.domain.couple.entity.Couple;
import com.ssafy.lovesol.domain.datelog.dto.response.DateLogForCalenderResponseDto;
import com.ssafy.lovesol.domain.datelog.dto.response.DateLogResponseDto;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class DateLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long dateLogId;

    @Column(nullable = false)
    private LocalDate dateAt;

    @Column(nullable = false)
    private int mileage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "couple_id", nullable = false)
    private Couple couple;

    @OneToMany(mappedBy = "dateLog", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PaymentLog> paymentLogList;

    @OneToMany(mappedBy = "dateLog", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Image> imageList;

    public DateLogForCalenderResponseDto toDateLogForCalenderResponseDto(){
        return DateLogForCalenderResponseDto.builder()
                .dateLogId(dateLogId)
                .dateAt(dateAt)
                .build();
    }
  
    public void accumulateMileage(int mileage) {
        this.mileage += mileage;
    }

    public static DateLog create(Couple couple, LocalDate dateAt){
        return DateLog.builder()
                .couple(couple)
                .dateAt(dateAt)
                .build();
    }

    public DateLogResponseDto toDateLogResponseDto(){


        return DateLogResponseDto.builder()
                .dateLogId(dateLogId)
                .dateAt(dateAt)
                .mileage(mileage)
                .paymentLogList(paymentLogList)
                .imageList(imageList.stream().map(image -> image.toImageResponseDto()).collect(Collectors.toList()))
                .build();
    }
}
