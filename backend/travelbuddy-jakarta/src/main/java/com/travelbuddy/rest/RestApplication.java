package com.travelbuddy.rest;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

/**
 * JAX-RS Application configuration.
 * Sets the base path for all REST endpoints.
 */
@ApplicationPath("/api")
public class RestApplication extends Application {
    // No additional configuration needed
    // All @Path annotated classes will be automatically discovered
}
