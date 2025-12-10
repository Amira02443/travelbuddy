package com.travelbuddy.service;

import com.travelbuddy.model.Activity;
import com.travelbuddy.repository.ActivityRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for Activity business logic.
 */
public class ActivityService {

    private static ActivityService instance;
    private ActivityRepository activityRepository = ActivityRepository.getInstance();

    public static synchronized ActivityService getInstance() {
        if (instance == null) {
            instance = new ActivityService();
        }
        return instance;
    }

    public List<Activity> getAllActivities() {
        return activityRepository.findAll();
    }

    public Optional<Activity> getActivityById(Long id) {
        return activityRepository.findById(id);
    }

    public List<Activity> getActivitiesByCity(String city) {
        return activityRepository.findByCity(city);
    }

    public List<Activity> getActivitiesByType(String type) {
        return activityRepository.findByType(type);
    }

    public List<Activity> getActivitiesByCityAndTypes(String city, List<String> types) {
        return activityRepository.findByCityAndTypes(city, types);
    }

    public List<Activity> getActivitiesByCityAndBudget(String city, double maxCost) {
        return activityRepository.findByCityAndBudget(city, maxCost);
    }

    public Activity createActivity(Activity activity) {
        return activityRepository.save(activity);
    }

    public Activity updateActivity(Long id, Activity activity) {
        activity.setId(id);
        return activityRepository.save(activity);
    }

    public void deleteActivity(Long id) {
        activityRepository.deleteById(id);
    }

    public List<String> getActivityTypes() {
        return activityRepository.findDistinctTypes();
    }

    public List<String> getActivityTypesByCity(String city) {
        return activityRepository.findDistinctTypesByCity(city);
    }
}
