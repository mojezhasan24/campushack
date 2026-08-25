package com.hackathon.controller.web;

import com.hackathon.entity.Notification;
import com.hackathon.entity.User;
import com.hackathon.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping
    public String viewNotifications(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        List<Notification> notifications = notificationService.getUserNotifications(loggedInUser);
        model.addAttribute("notifications", notifications);
        return "notifications";
    }
}
