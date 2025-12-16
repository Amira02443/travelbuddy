package com.travelbuddy.rest;

import jakarta.inject.Inject;
import jakarta.servlet.ServletContext;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Response;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@Path("/images")
public class ImageResource {

    @Inject
    private ServletContext servletContext;
    @GET
    @Path("/{imageName}")
    @Produces({"image/jpeg", "image/png", "image/gif", "image/webp"})
    public Response getImage(@PathParam("imageName") String imageName) {
        try {
            String decodedName = URLDecoder.decode(imageName, StandardCharsets.UTF_8);
            
            if (decodedName.contains("..") || decodedName.startsWith("/")) {
                return Response.status(Response.Status.BAD_REQUEST).build();
            }

            String imagePath = servletContext.getRealPath("/images/" + decodedName);
            if (imagePath == null) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            File imageFile = new File(imagePath);
            if (!imageFile.exists() || !imageFile.getAbsolutePath().contains(File.separator + "images" + File.separator)) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            return Response.ok(new FileInputStream(imageFile))
                    .header("Content-Type", determineContentType(decodedName))
                    .header("Cache-Control", "public, max-age=86400")
                    .header("Access-Control-Allow-Origin", "*")
                    .build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).build();
        }
    }
    private String determineContentType(String filename) {
        if (filename.toLowerCase().endsWith(".jpg") || filename.toLowerCase().endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (filename.toLowerCase().endsWith(".png")) {
            return "image/png";
        } else if (filename.toLowerCase().endsWith(".gif")) {
            return "image/gif";
        } else if (filename.toLowerCase().endsWith(".webp")) {
            return "image/webp";
        }
        return "application/octet-stream";
    }
}
