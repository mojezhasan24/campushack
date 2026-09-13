package com.hackathon.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@Profile("dev")
public class LocalFileStorageService implements FileStorageService {

    @Value("${app.upload.dir:./uploads}")
    private String uploadDir;

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final List<String> ALLOWED_MIME_TYPES = Arrays.asList(
            "image/jpeg", "image/png", "application/pdf"
    );

    @Override
    public String uploadFile(MultipartFile file, String prefix) throws IOException {
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File size exceeds maximum limit of 5MB");
        }

        String mimeType = file.getContentType();
        if (mimeType == null || !ALLOWED_MIME_TYPES.contains(mimeType)) {
            throw new IllegalArgumentException("Invalid file type. Only JPG, PNG, and PDF are allowed.");
        }

        String targetDir = uploadDir + "/" + prefix + "/";
        File dir = new File(targetDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            String ext = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
            if (ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".pdf")) {
                extension = ext;
            } else {
                throw new IllegalArgumentException("Invalid file extension.");
            }
        }

        String newFilename = UUID.randomUUID().toString() + extension;
        Path filePath = Paths.get(targetDir + newFilename);
        Files.write(filePath, file.getBytes());

        return "/uploads/" + prefix + "/" + newFilename;
    }
}
