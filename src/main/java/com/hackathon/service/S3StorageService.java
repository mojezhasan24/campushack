package com.hackathon.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.net.URI;
import java.util.UUID;
import org.springframework.context.annotation.Profile;

@Service
@Profile("prod")
public class S3StorageService implements FileStorageService {

    private final S3Client s3Client;
    private final String bucketName;
    private final String publicUrlPrefix;

    public S3StorageService(
            @Value("${aws.s3.endpointUrl:}") String endpointUrl,
            @Value("${aws.s3.region:auto}") String region,
            @Value("${aws.s3.accessKeyId:}") String accessKeyId,
            @Value("${aws.s3.secretAccessKey:}") String secretAccessKey,
            @Value("${aws.s3.bucketName:}") String bucketName,
            @Value("${aws.s3.publicUrlPrefix:}") String publicUrlPrefix
    ) {
        this.bucketName = bucketName;
        this.publicUrlPrefix = publicUrlPrefix;

        if (accessKeyId.isEmpty() || secretAccessKey.isEmpty()) {
            this.s3Client = null; // Mock / Dev mode if not configured
            return;
        }

        AwsBasicCredentials credentials = AwsBasicCredentials.create(accessKeyId, secretAccessKey);
        
        S3Client.Builder builder = S3Client.builder()
                .credentialsProvider(StaticCredentialsProvider.create(credentials))
                .region(Region.of(region));

        if (!endpointUrl.isEmpty()) {
            builder.endpointOverride(URI.create(endpointUrl));
            // Cloudflare R2 / Custom S3 endpoints usually require path style access
            builder.serviceConfiguration(S3Configuration.builder().pathStyleAccessEnabled(true).build());
        }

        this.s3Client = builder.build();
    }

    public String uploadFile(MultipartFile file, String prefix) throws IOException {
        if (s3Client == null) {
            // Mock upload for local development if S3 is not configured
            return "/mock-uploads/" + prefix + "-" + file.getOriginalFilename();
        }

        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String objectKey = prefix + "/" + UUID.randomUUID().toString() + extension;

        PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(objectKey)
                .contentType(file.getContentType())
                .build();

        s3Client.putObject(putObjectRequest, 
                RequestBody.fromInputStream(file.getInputStream(), file.getSize()));

        // If a public URL prefix is configured (e.g. custom domain for R2), use it.
        // Otherwise, construct a generic S3 URL (works for standard AWS S3 if public).
        if (publicUrlPrefix != null && !publicUrlPrefix.isEmpty()) {
            String baseUrl = publicUrlPrefix.endsWith("/") ? publicUrlPrefix : publicUrlPrefix + "/";
            return baseUrl + objectKey;
        } else {
            return s3Client.utilities().getUrl(b -> b.bucket(bucketName).key(objectKey)).toExternalForm();
        }
    }
}
