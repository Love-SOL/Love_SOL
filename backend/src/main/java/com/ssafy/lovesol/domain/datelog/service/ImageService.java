package com.ssafy.lovesol.domain.datelog.service;

import com.ssafy.lovesol.domain.datelog.dto.request.UpdateImageDto;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface ImageService {
    Image getImage(Long ImageId);
    void updateImage(Long imageId, MultipartFile imageFile, String content) throws IOException;
    void deleteImage(Long imageId);
}
