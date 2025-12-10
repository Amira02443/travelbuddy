package com.travelbuddy.model;

import jakarta.xml.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Wrapper class for XML list of trips.
 */
@XmlRootElement(name = "trips")
@XmlAccessorType(XmlAccessType.FIELD)
public class Trips {

    @XmlElement(name = "trip")
    private List<Trip> trips = new ArrayList<>();

    public Trips() {
    }

    public Trips(List<Trip> trips) {
        this.trips = trips;
    }

    public List<Trip> getTrips() {
        if (trips == null) {
            trips = new ArrayList<>();
        }
        return trips;
    }

    public void setTrips(List<Trip> trips) {
        this.trips = trips;
    }

    public void addTrip(Trip trip) {
        if (this.trips == null) {
            this.trips = new ArrayList<>();
        }
        this.trips.add(trip);
    }
}
