package com.travelbuddy.model;

import jakarta.xml.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Represents a planned trip.
 */
@XmlRootElement(name = "trip")
@XmlAccessorType(XmlAccessType.FIELD)
public class Trip {

    @XmlAttribute
    private Long id;

    @XmlElement
    private String name;

    @XmlElement
    private Long userId;

    @XmlElement
    private String city;

    @XmlElement
    private String startDate;

    @XmlElement
    private String endDate;

    @XmlElement
    private int numberOfDays;

    @XmlElement
    private double budget;

    @XmlElementWrapper(name = "activityIds")
    @XmlElement(name = "activityId")
    private List<Long> activityIds = new ArrayList<>();

    @XmlElement
    private String status; // PLANNED, COMPLETED, CANCELLED

    @XmlElement
    private String createdAt;

    // Default constructor for JAXB
    public Trip() {
    }

    // Full constructor
    public Trip(Long id, String name, Long userId, String city, String startDate, String endDate, double budget) {
        this.id = id;
        this.name = name;
        this.userId = userId;
        this.city = city;
        this.startDate = startDate;
        this.endDate = endDate;
        this.budget = budget;
        this.status = "PLANNED";
        this.activityIds = new ArrayList<>();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public int getNumberOfDays() {
        return numberOfDays;
    }

    public void setNumberOfDays(int numberOfDays) {
        this.numberOfDays = numberOfDays;
    }

    public double getBudget() {
        return budget;
    }

    public void setBudget(double budget) {
        this.budget = budget;
    }

    public List<Long> getActivityIds() {
        return activityIds;
    }

    public void setActivityIds(List<Long> activityIds) {
        this.activityIds = activityIds;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public void addActivityId(Long activityId) {
        if (this.activityIds == null) {
            this.activityIds = new ArrayList<>();
        }
        this.activityIds.add(activityId);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        Trip trip = (Trip) o;
        return Objects.equals(id, trip.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "Trip{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", city='" + city + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
