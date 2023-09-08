package com.ssafy.lovesol.domain.datelog.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.ssafy.lovesol.domain.datelog.dto.request.UpdateImageDto;
import com.ssafy.lovesol.domain.datelog.entity.Image;
import com.ssafy.lovesol.domain.datelog.repository.ImageRepository;
import com.ssafy.lovesol.global.exception.NotExistImageException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

@Slf4j
@RequiredArgsConstructor
@Service
public class ImageServiceImple implements ImageService{
    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;
    final private ImageRepository imageRepository;
    @Override
    public Image getImage(Long imageId) {
        return imageRepository.findById(imageId).orElseThrow(NotExistImageException::new);
    }

    @Override
    @Transactional
    public void updateImage(Long imageId, MultipartFile imageFile, String content) throws IOException {
        Image image = imageRepository.findById(imageId).orElseThrow(NotExistImageException::new);

        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentType(imageFile.getContentType());
        objectMetadata.setContentLength(imageFile.getSize());

        String originalFileName = imageFile.getOriginalFilename();
        int index = originalFileName.lastIndexOf(".");
        String ext = originalFileName.substring(index + 1);

        String storeFileName = UUID.randomUUID() + "." + ext;
        String key = "date-log/" + storeFileName;

        try (InputStream inputStream = imageFile.getInputStream()) {
            amazonS3.putObject(new PutObjectRequest(bucket, key, inputStream, objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead));
        }

        String storeFileUrl = amazonS3.getUrl(bucket, key).toString();

        image.updateImageUrl(storeFileUrl);
        image.updateContent(content);
        // TODO: S3에 이미지 변경하기
    }

    @Override
    public void deleteImage(Long imageId) {
        Image image = imageRepository.findById(imageId).orElseThrow(NotExistImageException::new);
        imageRepository.delete(image);
    }
}
