package com.travelbuddy.model;

import jakarta.xml.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Request object for the SOAP itinerary builder service.
 */
@XmlRootElement(name = "itineraryRequest")
@XmlAccessorType(XmlAccessType.FIELD)
public class ItineraryRequest {

    @XmlElement
    private String city;

    @XmlElement
    private double budget;

    @XmlElement
    private int duration; // in days

    @XmlElementWrapper(name = "activityTypes")
    @XmlElement(name = "type")
    private List<String> activityTypes = new ArrayList<>();

    @XmlElement
    private String preference; // relaxed, balanced, intensive

    // Default constructor for JAXB
    public ItineraryRequest() {
    }

    // Full constructor
    public ItineraryRequest(String city, double budget, int duration,
            List<String> activityTypes, String preference) {
        this.city = city;
        this.budget = budget;
        this.duration = duration;
        this.activityTypes = activityTypes;
        this.preference = preference;
    }

    // Getters and Setters
    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public double getBudget() {
        return budget;
    }

    public void setBudget(double budget) {
        this.budget = budget;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public List<String> getActivityTypes() {
        return activityTypes;
    }

    public void setActivityTypes(List<String> activityTypes) {
        this.activityTypes = activityTypes;
    }

    public String getPreference() {
        return preference;
    }

    public void setPreference(String preference) {
        this.preference = preference;
    }

    @Override
    public String toString() {
        return "ItineraryRequest{" +
                "city='" + city + '\'' +
                ", budget=" + budget +
                ", duration=" + duration +
                ", activityTypes=" + activityTypes +
                ", preference='" + preference + '\'' +
                '}';
    }
}
