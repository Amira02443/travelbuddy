package com.travelbuddy.filter;

import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerResponseContext;
import jakarta.ws.rs.container.ContainerResponseFilter;
import jakarta.ws.rs.ext.Provider;
import java.io.IOException;

/**
 * Filter to enable Cross-Origin Resource Sharing (CORS).
 * Essential for the Flutter mobile app to communicate with the backend.
 */
@Provider
public class CorsFilter implements ContainerResponseFilter {

        @Override
        public void filter(ContainerRequestContext requestContext, ContainerResponseContext responseContext)
                        throws IOException {
                responseContext.getHeaders().add("Access-Control-Allow-Origin", "*");
                responseContext.getHeaders().add("Access-Control-Allow-Headers",
                                "origin, content-type, accept, authorization");
                responseContext.getHeaders().add("Access-Control-Allow-Credentials", "true");
                responseContext.getHeaders().add("Access-Control-Allow-Methods",
                                "GET, POST, PUT, DELETE, OPTIONS, HEAD");
        }
}
