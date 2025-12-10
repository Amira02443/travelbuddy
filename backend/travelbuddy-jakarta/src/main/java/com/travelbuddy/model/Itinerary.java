package com.travelbuddy.model;

import jakarta.xml.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Response object from the SOAP itinerary builder service.
 */
@XmlRootElement(name = "itineraryResponse")
@XmlAccessorType(XmlAccessType.FIELD)
public class Itinerary {

    @XmlElement
    private boolean success;

    @XmlElement
    private String message;

    @XmlElement
    private String city;

    @XmlElement
    private double totalCost;

    @XmlElement
    private double remainingBudget;

    @XmlElement
    private int totalDays;

    @XmlElement
    private int totalActivities;

    @XmlElementWrapper(name = "days")
    @XmlElement(name = "day")
    private List<ItineraryDay> days = new ArrayList<>();

    // Default constructor
    public Itinerary() {
    }

    // Success constructor
    public Itinerary(String city, int totalDays) {
        this.success = true;
        this.city = city;
        this.totalDays = totalDays;
        this.days = new ArrayList<>();
        this.totalCost = 0.0;
        this.totalActivities = 0;
    }

    // Error constructor
    public Itinerary(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    // Getters and Setters
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public double getRemainingBudget() {
        return remainingBudget;
    }

    public void setRemainingBudget(double remainingBudget) {
        this.remainingBudget = remainingBudget;
    }

    public int getTotalDays() {
        return totalDays;
    }

    public void setTotalDays(int totalDays) {
        this.totalDays = totalDays;
    }

    public int getTotalActivities() {
        return totalActivities;
    }

    public void setTotalActivities(int totalActivities) {
        this.totalActivities = totalActivities;
    }

    public List<ItineraryDay> getDays() {
        return days;
    }

    public void setDays(List<ItineraryDay> days) {
        this.days = days;
        calculateTotals();
    }

    public void addDay(ItineraryDay day) {
        if (this.days == null) {
            this.days = new ArrayList<>();
        }
        this.days.add(day);
        this.totalCost += day.getDayCost();
        this.totalActivities += day.getActivities().size();
    }

    private void calculateTotals() {
        this.totalCost = days.stream().mapToDouble(ItineraryDay::getDayCost).sum();
        this.totalActivities = days.stream().mapToInt(d -> d.getActivities().size()).sum();
    }

    @Override
    public String toString() {
        return "Itinerary{" +
                "success=" + success +
                ", city='" + city + '\'' +
                ", totalCost=" + totalCost +
                ", totalDays=" + totalDays +
                ", totalActivities=" + totalActivities +
                '}';
    }
}
