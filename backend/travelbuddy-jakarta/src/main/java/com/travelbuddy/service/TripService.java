package com.travelbuddy.service;

import com.travelbuddy.model.Trip;
import com.travelbuddy.repository.TripRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for Trip business logic.
 */
public class TripService {

    private static TripService instance;
    private TripRepository tripRepository = TripRepository.getInstance();

    public static synchronized TripService getInstance() {
        if (instance == null) {
            instance = new TripService();
        }
        return instance;
    }

    public List<Trip> getAllTrips() {
        return tripRepository.findAll();
    }

    public Optional<Trip> getTripById(Long id) {
        return tripRepository.findById(id);
    }

    public List<Trip> getTripsByUserId(Long userId) {
        return tripRepository.findByUserId(userId);
    }

    public List<Trip> getTripsByCity(String city) {
        return tripRepository.findByCity(city);
    }

    public List<Trip> getTripsByStatus(String status) {
        return tripRepository.findByStatus(status);
    }

    public Trip createTrip(Trip trip) {
        return tripRepository.save(trip);
    }

    public Trip updateTrip(Long id, Trip trip) {
        Optional<Trip> existing = tripRepository.findById(id);
        if (existing.isEmpty()) {
            throw new IllegalArgumentException("Trip not found");
        }
        trip.setId(id);
        trip.setCreatedAt(existing.get().getCreatedAt());
        return tripRepository.save(trip);
    }

    public void deleteTrip(Long id) {
        tripRepository.deleteById(id);
    }

    public Trip addActivityToTrip(Long tripId, Long activityId) {
        Optional<Trip> tripOpt = tripRepository.findById(tripId);
        if (tripOpt.isEmpty()) {
            throw new IllegalArgumentException("Trip not found");
        }
        Trip trip = tripOpt.get();
        trip.addActivityId(activityId);
        return tripRepository.save(trip);
    }

    public Trip updateTripStatus(Long id, String status) {
        Optional<Trip> tripOpt = tripRepository.findById(id);
        if (tripOpt.isEmpty()) {
            throw new IllegalArgumentException("Trip not found");
        }
        Trip trip = tripOpt.get();
        trip.setStatus(status);
        return tripRepository.save(trip);
    }
}
