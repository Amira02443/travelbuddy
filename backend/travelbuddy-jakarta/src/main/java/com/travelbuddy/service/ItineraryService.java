package com.travelbuddy.service;

import com.travelbuddy.model.*;
import com.travelbuddy.repository.ActivityRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service for building itineraries using a rule-based algorithm.
 * This is the core business logic for the SOAP service.
 */
public class ItineraryService {

    private static ItineraryService instance;
    private ActivityRepository activityRepository = ActivityRepository.getInstance();

    public static synchronized ItineraryService getInstance() {
        if (instance == null) {
            instance = new ItineraryService();
        }
        return instance;
    }

    // Time slots configuration
    private static final String[] TIME_SLOTS = { "morning", "afternoon", "evening" };
    private static final Map<String, String[]> TIME_RANGES = Map.of(
            "morning", new String[] { "09:00", "12:00" },
            "afternoon", new String[] { "14:00", "18:00" },
            "evening", new String[] { "19:00", "22:00" });

    // Activities per day based on preference
    private static final Map<String, Integer> ACTIVITIES_PER_DAY = Map.of(
            "relaxed", 2,
            "balanced", 3,
            "intensive", 4);

    /**
     * Build an itinerary based on the user's request.
     * Uses a rule-based algorithm (no AI).
     */
    public Itinerary buildItinerary(ItineraryRequest request) {
        // Validate request
        if (request.getCity() == null || request.getCity().isEmpty()) {
            return new Itinerary(false, "City is required");
        }
        if (request.getDuration() <= 0 || request.getDuration() > 14) {
            return new Itinerary(false, "Duration must be between 1 and 14 days");
        }
        if (request.getBudget() <= 0) {
            return new Itinerary(false, "Budget must be positive");
        }

        // Get available activities for the city
        List<Activity> availableActivities = activityRepository.findByCity(request.getCity());

        if (availableActivities.isEmpty()) {
            return new Itinerary(false, "No activities found for city: " + request.getCity());
        }

        // Filter by activity types if specified
        if (request.getActivityTypes() != null && !request.getActivityTypes().isEmpty()) {
            List<String> types = request.getActivityTypes().stream()
                    .map(String::toLowerCase)
                    .collect(Collectors.toList());
            availableActivities = availableActivities.stream()
                    .filter(a -> types.contains(a.getType().toLowerCase()))
                    .collect(Collectors.toList());
        }

        if (availableActivities.isEmpty()) {
            return new Itinerary(false, "No activities match the selected types");
        }

        // Sort by rating (best first) and cost (cheaper first for equal ratings)
        availableActivities.sort((a, b) -> {
            int ratingCompare = Double.compare(b.getRating(), a.getRating());
            if (ratingCompare == 0) {
                return Double.compare(a.getCost(), b.getCost());
            }
            return ratingCompare;
        });

        // Create itinerary
        Itinerary itinerary = new Itinerary(request.getCity(), request.getDuration());

        String preference = request.getPreference() != null ? request.getPreference().toLowerCase() : "balanced";
        int activitiesPerDay = ACTIVITIES_PER_DAY.getOrDefault(preference, 3);

        double remainingBudget = request.getBudget();
        Set<Long> usedActivityIds = new HashSet<>();
        LocalDate startDate = LocalDate.now();

        // Build each day
        for (int day = 1; day <= request.getDuration(); day++) {
            ItineraryDay itineraryDay = new ItineraryDay(day,
                    startDate.plusDays(day - 1).format(DateTimeFormatter.ISO_LOCAL_DATE));

            int activitiesAdded = 0;

            // Try to add activities for each time slot
            for (String timeSlot : TIME_SLOTS) {
                if (activitiesAdded >= activitiesPerDay)
                    break;

                // Find best available activity for this time slot
                double currentBudget = remainingBudget;
                Optional<Activity> bestActivity = availableActivities.stream()
                        .filter(a -> !usedActivityIds.contains(a.getId()))
                        .filter(a -> a.getCost() <= currentBudget)
                        .filter(a -> a.getTimeSlot() == null ||
                                a.getTimeSlot().equalsIgnoreCase(timeSlot) ||
                                a.getTimeSlot().isEmpty())
                        .findFirst();

                if (bestActivity.isPresent()) {
                    Activity activity = bestActivity.get();
                    String[] times = TIME_RANGES.get(timeSlot);

                    ScheduledActivity scheduled = new ScheduledActivity(
                            activity.getId(),
                            activity.getName(),
                            times[0],
                            times[1],
                            activity.getCost(),
                            activity.getType(),
                            activity.getDescription());

                    itineraryDay.addActivity(scheduled);
                    usedActivityIds.add(activity.getId());
                    remainingBudget -= activity.getCost();
                    activitiesAdded++;
                }
            }

            if (itineraryDay.getActivities().size() > 0) {
                itinerary.addDay(itineraryDay);
            }
        }

        // Set final values
        itinerary.setRemainingBudget(remainingBudget);
        itinerary.setSuccess(true);
        itinerary.setMessage("Itinerary generated successfully");

        return itinerary;
    }

    /**
     * Get available activity types for a city.
     */
    public List<String> getActivityTypes(String city) {
        if (city == null || city.isEmpty()) {
            return activityRepository.findDistinctTypes();
        }
        return activityRepository.findDistinctTypesByCity(city);
    }
}
