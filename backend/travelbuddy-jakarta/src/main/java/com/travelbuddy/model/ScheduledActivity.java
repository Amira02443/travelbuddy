package com.travelbuddy.model;

import jakarta.xml.bind.annotation.*;

/**
 * Represents a scheduled activity within a day of the itinerary.
 */
@XmlRootElement(name = "scheduledActivity")
@XmlAccessorType(XmlAccessType.FIELD)
public class ScheduledActivity {

    @XmlElement
    private Long activityId;

    @XmlElement
    private String name;

    @XmlElement
    private String startTime;

    @XmlElement
    private String endTime;

    @XmlElement
    private double cost;

    @XmlElement
    private String type;

    @XmlElement
    private String description;

    // Default constructor
    public ScheduledActivity() {
    }

    // Full constructor
    public ScheduledActivity(Long activityId, String name, String startTime,
            String endTime, double cost, String type, String description) {
        this.activityId = activityId;
        this.name = name;
        this.startTime = startTime;
        this.endTime = endTime;
        this.cost = cost;
        this.type = type;
        this.description = description;
    }

    // Getters and Setters
    public Long getActivityId() {
        return activityId;
    }

    public void setActivityId(Long activityId) {
        this.activityId = activityId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public double getCost() {
        return cost;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
