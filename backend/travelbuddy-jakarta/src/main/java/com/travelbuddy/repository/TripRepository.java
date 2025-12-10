package com.travelbuddy.repository;

import com.travelbuddy.model.Trips;
import com.travelbuddy.model.Trip;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.bind.Unmarshaller;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.annotation.PostConstruct;

import java.io.InputStream;
import java.io.FileOutputStream;
import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Repository for Trip entities using XML as storage.
 */
@ApplicationScoped
public class TripRepository {

    private static TripRepository instance;

    public static synchronized TripRepository getInstance() {
        if (instance == null) {
            instance = new TripRepository();
            instance.init();
        }
        return instance;
    }

    private static final String XML_FILE = "data/trips.xml";
    private Trips trips;
    private JAXBContext context;

    public void init() {
        try {
            context = JAXBContext.newInstance(Trips.class);
            loadFromXml();
        } catch (JAXBException e) {
            e.printStackTrace();
            trips = new Trips();
        }
    }

    private void loadFromXml() {
        try {
            Unmarshaller unmarshaller = context.createUnmarshaller();
            InputStream is = getClass().getClassLoader().getResourceAsStream(XML_FILE);
            if (is != null) {
                trips = (Trips) unmarshaller.unmarshal(is);
            } else {
                trips = new Trips();
            }
        } catch (JAXBException e) {
            e.printStackTrace();
            trips = new Trips();
        }
    }

    private void saveToXml() {
        try {
            Marshaller marshaller = context.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

            java.net.URL resource = getClass().getClassLoader().getResource(XML_FILE);
            if (resource != null) {
                File file = new File(resource.toURI());
                marshaller.marshal(trips, new FileOutputStream(file));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Trip> findAll() {
        if (trips == null || trips.getTrips() == null) {
            return new ArrayList<>();
        }
        return new ArrayList<>(trips.getTrips());
    }

    public Optional<Trip> findById(Long id) {
        return findAll().stream()
                .filter(t -> t.getId().equals(id))
                .findFirst();
    }

    public List<Trip> findByUserId(Long userId) {
        return findAll().stream()
                .filter(t -> t.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    public List<Trip> findByCity(String city) {
        return findAll().stream()
                .filter(t -> t.getCity().equalsIgnoreCase(city))
                .collect(Collectors.toList());
    }

    public List<Trip> findByStatus(String status) {
        return findAll().stream()
                .filter(t -> t.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());
    }

    public Trip save(Trip trip) {
        if (trip.getId() == null) {
            Long maxId = findAll().stream()
                    .mapToLong(Trip::getId)
                    .max()
                    .orElse(0L);
            trip.setId(maxId + 1);
            trip.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            if (trip.getStatus() == null) {
                trip.setStatus("planned");
            }
        } else {
            trips.getTrips().removeIf(t -> t.getId().equals(trip.getId()));
        }
        trips.addTrip(trip);
        saveToXml();
        return trip;
    }

    public void deleteById(Long id) {
        trips.getTrips().removeIf(t -> t.getId().equals(id));
        saveToXml();
    }
}
