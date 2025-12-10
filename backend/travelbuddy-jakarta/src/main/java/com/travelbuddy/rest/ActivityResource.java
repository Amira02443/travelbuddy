package com.travelbuddy.rest;

import com.travelbuddy.model.Activity;
import com.travelbuddy.service.ActivityService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

/**
 * REST Resource for Activity CRUD operations.
 */
@Path("/activities")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ActivityResource {

    private ActivityService activityService = ActivityService.getInstance();

    @GET
    public Response getAllActivities() {
        List<Activity> activities = activityService.getAllActivities();
        return Response.ok(activities).build();
    }

    @GET
    @Path("/{id}")
    public Response getActivityById(@PathParam("id") Long id) {
        return activityService.getActivityById(id)
                .map(activity -> Response.ok(activity).build())
                .orElse(Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Activity not found\"}")
                        .build());
    }

    @GET
    @Path("/city/{city}")
    public Response getActivitiesByCity(@PathParam("city") String city) {
        List<Activity> activities = activityService.getActivitiesByCity(city);
        return Response.ok(activities).build();
    }

    @GET
    @Path("/type/{type}")
    public Response getActivitiesByType(@PathParam("type") String type) {
        List<Activity> activities = activityService.getActivitiesByType(type);
        return Response.ok(activities).build();
    }

    @GET
    @Path("/types")
    public Response getActivityTypes(@QueryParam("city") String city) {
        List<String> types = city != null && !city.isEmpty()
                ? activityService.getActivityTypesByCity(city)
                : activityService.getActivityTypes();
        return Response.ok(types).build();
    }

    @POST
    public Response createActivity(Activity activity) {
        try {
            Activity created = activityService.createActivity(activity);
            return Response.status(Response.Status.CREATED).entity(created).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateActivity(@PathParam("id") Long id, Activity activity) {
        try {
            Activity updated = activityService.updateActivity(id, activity);
            return Response.ok(updated).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteActivity(@PathParam("id") Long id) {
        activityService.deleteActivity(id);
        return Response.noContent().build();
    }
}
