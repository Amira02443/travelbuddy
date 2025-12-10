package com.travelbuddy.model;

import jakarta.xml.bind.annotation.*;
import java.util.Objects;

/**
 * Represents an activity that can be included in a trip itinerary.
 */
@XmlRootElement(name = "activity")
@XmlAccessorType(XmlAccessType.FIELD)
public class Activity {

    @XmlAttribute
    private Long id;

    @XmlElement
    private String name;

    @XmlElement
    private String city;

    @XmlElement
    private String type; // landmark, museum, restaurant, nature, shopping, nightlife

    @XmlElement
    private int duration; // in hours

    @XmlElement
    private double cost;

    @XmlElement
    private double rating;

    @XmlElement
    private String description;

    @XmlElement
    private String timeSlot; // morning, afternoon, evening

    @XmlElement
    private String image;

    // Default constructor for JAXB
    public Activity() {
    }

    // Full constructor
    public Activity(Long id, String name, String city, String type, int duration,
            double cost, double rating, String description, String timeSlot, String image) {
        this.id = id;
        this.name = name;
        this.city = city;
        this.type = type;
        this.duration = duration;
        this.cost = cost;
        this.rating = rating;
        this.description = description;
        this.timeSlot = timeSlot;
        this.image = image;
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

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public double getCost() {
        return cost;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        Activity activity = (Activity) o;
        return Objects.equals(id, activity.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "Activity{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", city='" + city + '\'' +
                ", type='" + type + '\'' +
                ", cost=" + cost +
                '}';
    }
}
