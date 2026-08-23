package com.hackathon.config;

import com.hackathon.entity.Role;
import com.hackathon.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AdminSecurityInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && user.getRole() == Role.ADMIN) {
                return true;
            }
        }
        
        // Handle non-admin or unauthenticated request
        String acceptHeader = request.getHeader("Accept");
        if (acceptHeader != null && acceptHeader.contains("application/json")) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Forbidden\", \"message\": \"Access denied. Admin role required.\"}");
        } else {
            response.sendRedirect(request.getContextPath() + "/login?error=AccessDenied");
        }
        return false;
    }
}
