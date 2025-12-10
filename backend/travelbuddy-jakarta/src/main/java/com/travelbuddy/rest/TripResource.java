package com.travelbuddy.rest;

import com.travelbuddy.model.Trip;
import com.travelbuddy.service.TripService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

/**
 * REST Resource for Trip CRUD operations.
 */
@Path("/trips")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TripResource {

    private TripService tripService = TripService.getInstance();

    @GET
    public Response getAllTrips() {
        List<Trip> trips = tripService.getAllTrips();
        return Response.ok(trips).build();
    }

    @GET
    @Path("/{id}")
    public Response getTripById(@PathParam("id") Long id) {
        return tripService.getTripById(id)
                .map(trip -> Response.ok(trip).build())
                .orElse(Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Trip not found\"}")
                        .build());
    }

    @GET
    @Path("/user/{userId}")
    public Response getTripsByUserId(@PathParam("userId") Long userId) {
        List<Trip> trips = tripService.getTripsByUserId(userId);
        return Response.ok(trips).build();
    }

    @GET
    @Path("/city/{city}")
    public Response getTripsByCity(@PathParam("city") String city) {
        List<Trip> trips = tripService.getTripsByCity(city);
        return Response.ok(trips).build();
    }

    @POST
    public Response createTrip(Trip trip) {
        try {
            Trip created = tripService.createTrip(trip);
            return Response.status(Response.Status.CREATED).entity(created).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateTrip(@PathParam("id") Long id, Trip trip) {
        try {
            Trip updated = tripService.updateTrip(id, trip);
            return Response.ok(updated).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteTrip(@PathParam("id") Long id) {
        tripService.deleteTrip(id);
        return Response.noContent().build();
    }

    @POST
    @Path("/{tripId}/activities/{activityId}")
    public Response addActivityToTrip(
            @PathParam("tripId") Long tripId,
            @PathParam("activityId") Long activityId) {
        try {
            Trip updated = tripService.addActivityToTrip(tripId, activityId);
            return Response.ok(updated).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @PATCH
    @Path("/{id}/status")
    public Response updateTripStatus(@PathParam("id") Long id, @QueryParam("status") String status) {
        try {
            Trip updated = tripService.updateTripStatus(id, status);
            return Response.ok(updated).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
}
