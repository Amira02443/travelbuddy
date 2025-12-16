package com.travelbuddy.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Global CORS Filter to enable Cross-Origin Resource Sharing for ALL endpoints.
 * This includes both REST (/api/*) and SOAP (/ws/*) endpoints.
 */
public class GlobalCorsFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Allow all origins (for development) - change to specific domains in production
        httpResponse.setHeader("Access-Control-Allow-Origin", "*");
        
        // Allow common methods
        httpResponse.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS, HEAD");
        
        // Allow common headers, including SOAP specific ones
        httpResponse.setHeader("Access-Control-Allow-Headers", 
            "origin, content-type, accept, authorization, SOAPAction");
        
        // Allow credentials
        httpResponse.setHeader("Access-Control-Allow-Credentials", "true");

        // Handle preflight OPTIONS requests
        if ("OPTIONS".equalsIgnoreCase(httpRequest.getMethod())) {
            httpResponse.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
