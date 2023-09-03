package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.datelog.dto.request.UpdateImageDto;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.repository.ImageRepository;
import com.ssafy.lovesol.global.exception.NotExistImageException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class ImageServiceImple implements ImageService{
    ImageRepository imageRepository;
    @Override
    public Image getImage(Long imageId) {
        // TODO: 이미지 not exist 예외 추가하기
        return imageRepository.findById(imageId).orElseThrow(NotExistImageException::new);
    }

    @Override
    public void updateImage(UpdateImageDto updateImageDto) {
        // TODO: 이미지 not exist 예외 추가하기
        Image image = imageRepository.findById(updateImageDto.getImageId()).orElseThrow(NotExistImageException::new);
        image.updateImageUrl(updateImageDto.getImgUrl());
        image.updateContent(updateImageDto.getContent());
        // TODO: S3에 이미지 변경하기
    }

    @Override
    public void deleteImage(Long imageId) {
        Image image = imageRepository.findById(imageId).orElseThrow(NotExistImageException::new);
        imageRepository.delete(image);
    }
}
