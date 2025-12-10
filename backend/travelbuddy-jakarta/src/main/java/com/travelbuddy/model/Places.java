package com.travelbuddy.model;

import jakarta.xml.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Wrapper class for XML list of places.
 */
@XmlRootElement(name = "places")
@XmlAccessorType(XmlAccessType.FIELD)
public class Places {

    @XmlElement(name = "place")
    private List<Place> places = new ArrayList<>();

    public Places() {
    }

    public Places(List<Place> places) {
        this.places = places;
    }

    public List<Place> getPlaces() {
        return places;
    }

    public void setPlaces(List<Place> places) {
        this.places = places;
    }

    public void addPlace(Place place) {
        if (this.places == null) {
            this.places = new ArrayList<>();
        }
        this.places.add(place);
    }
}
