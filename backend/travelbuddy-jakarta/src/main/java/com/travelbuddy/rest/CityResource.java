package com.travelbuddy.rest;

import com.travelbuddy.model.City;
import com.travelbuddy.repository.CityRepository;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

/**
 * REST Resource for City operations.
 */
@Path("/cities")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CityResource {

    private CityRepository cityRepository = CityRepository.getInstance();

    @GET
    public Response getAllCities() {
        List<City> cities = cityRepository.findAll();
        return Response.ok(cities).build();
    }

    @GET
    @Path("/{id}")
    public Response getCityById(@PathParam("id") Long id) {
        return cityRepository.findById(id)
                .map(city -> Response.ok(city).build())
                .orElse(Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"City not found\"}")
                        .build());
    }

    @GET
    @Path("/name/{name}")
    public Response getCityByName(@PathParam("name") String name) {
        return cityRepository.findByName(name)
                .map(city -> Response.ok(city).build())
                .orElse(Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"City not found\"}")
                        .build());
    }
}
