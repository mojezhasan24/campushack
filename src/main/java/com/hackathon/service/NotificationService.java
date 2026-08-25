package com.hackathon.service;

import com.hackathon.entity.Notification;
import com.hackathon.entity.User;
import com.hackathon.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;

    @Transactional
    public Notification createNotification(User recipient, String message, String type, String link) {
        Notification notification = Notification.builder()
                .user(recipient)
                .message(message)
                .type(type)
                .link(link)
                .readStatus(false)
                .build();
        return notificationRepository.save(notification);
    }

    public List<Notification> getUserNotifications(User user) {
        return notificationRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public long getUnreadCount(User user) {
        return notificationRepository.countByUserAndReadStatusFalse(user);
    }

    @Transactional
    public void markAsRead(Long notificationId, User user) {
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new IllegalArgumentException("Notification not found with ID: " + notificationId));
        if (notification.getUser().getId().equals(user.getId())) {
            notification.setReadStatus(true);
            notificationRepository.save(notification);
        }
    }
}
