package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.datelog.dto.request.UpdateImageDto;
import com.ssafy.lovesol.domain.datelog.entity.Image;

public interface ImageService {
    Image getImage(Long ImageId);
    void updateImage(Long imageId, UpdateImageDto updateImageDto);
    void deleteImage(Long imageId);
}
