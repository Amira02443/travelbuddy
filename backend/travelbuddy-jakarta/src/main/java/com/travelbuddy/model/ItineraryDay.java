package com.travelbuddy.model;

import jakarta.xml.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents a single day in the itinerary.
 */
@XmlRootElement(name = "itineraryDay")
@XmlAccessorType(XmlAccessType.FIELD)
public class ItineraryDay {

    @XmlAttribute
    private int dayNumber;

    @XmlElement
    private String date;

    @XmlElementWrapper(name = "activities")
    @XmlElement(name = "activity")
    private List<ScheduledActivity> activities = new ArrayList<>();

    @XmlElement
    private double dayCost;

    // Default constructor
    public ItineraryDay() {
    }

    // Full constructor
    public ItineraryDay(int dayNumber, String date) {
        this.dayNumber = dayNumber;
        this.date = date;
        this.activities = new ArrayList<>();
        this.dayCost = 0.0;
    }

    // Getters and Setters
    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public List<ScheduledActivity> getActivities() {
        return activities;
    }

    public void setActivities(List<ScheduledActivity> activities) {
        this.activities = activities;
        calculateDayCost();
    }

    public double getDayCost() {
        return dayCost;
    }

    public void setDayCost(double dayCost) {
        this.dayCost = dayCost;
    }

    public void addActivity(ScheduledActivity activity) {
        if (this.activities == null) {
            this.activities = new ArrayList<>();
        }
        this.activities.add(activity);
        this.dayCost += activity.getCost();
    }

    private void calculateDayCost() {
        this.dayCost = activities.stream().mapToDouble(ScheduledActivity::getCost).sum();
    }
}
