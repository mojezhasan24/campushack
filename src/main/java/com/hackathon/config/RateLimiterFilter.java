package com.hackathon.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class RateLimiterFilter extends OncePerRequestFilter {

    private final ConcurrentHashMap<String, RequestInfo> requests = new ConcurrentHashMap<>();
    private static final int MAX_REQUESTS = 5;
    private static final long TIME_WINDOW_MS = 60 * 1000; // 1 minute

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        if ("/api/auth/login".equals(request.getRequestURI()) && "POST".equalsIgnoreCase(request.getMethod())) {
            String clientIp = getClientIp(request);
            RequestInfo requestInfo = requests.computeIfAbsent(clientIp, k -> new RequestInfo());

            long now = System.currentTimeMillis();
            
            synchronized (requestInfo) {
                if (now - requestInfo.timestamp > TIME_WINDOW_MS) {
                    requestInfo.timestamp = now;
                    requestInfo.count.set(1);
                } else {
                    if (requestInfo.count.incrementAndGet() > MAX_REQUESTS) {
                        response.setStatus(429); // Too Many Requests
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\":false, \"message\":\"Too many login attempts. Please try again later.\"}");
                        return;
                    }
                }
            }
        }
        
        filterChain.doFilter(request, response);
    }

    private String getClientIp(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null || xfHeader.isEmpty() || !xfHeader.contains(request.getRemoteAddr())) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0].trim();
    }

    private static class RequestInfo {
        long timestamp = System.currentTimeMillis();
        AtomicInteger count = new AtomicInteger(0);
    }
}
