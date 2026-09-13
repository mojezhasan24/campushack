package com.hackathon.service;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
@Profile("!prod")
public class LocalFileStorageService implements FileStorageService {

    private final String UPLOAD_DIR = "uploads/";

    @Override
    public String uploadFile(MultipartFile file, String prefix) throws IOException {
        String targetDir = UPLOAD_DIR + prefix + "/";
        File dir = new File(targetDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String newFilename = UUID.randomUUID().toString() + extension;
        Path filePath = Paths.get(targetDir + newFilename);
        Files.write(filePath, file.getBytes());

        return "/" + targetDir + newFilename;
    }
}
