package com.travelbuddy.repository;

import com.travelbuddy.model.Activities;
import com.travelbuddy.model.Activity;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Marshaller;
import jakarta.xml.bind.Unmarshaller;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.annotation.PostConstruct;

import java.io.InputStream;
import java.io.FileOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Repository for Activity entities using XML as storage.
 */
@ApplicationScoped
public class ActivityRepository {

    private static ActivityRepository instance;

    public static synchronized ActivityRepository getInstance() {
        if (instance == null) {
            instance = new ActivityRepository();
            instance.init();
        }
        return instance;
    }

    private static final String XML_FILE = "data/activities.xml";
    private Activities activities;
    private JAXBContext context;

    public void init() {
        try {
            context = JAXBContext.newInstance(Activities.class);
            loadFromXml();
        } catch (JAXBException e) {
            e.printStackTrace();
            activities = new Activities();
        }
    }

    private void loadFromXml() {
        try {
            Unmarshaller unmarshaller = context.createUnmarshaller();
            InputStream is = getClass().getClassLoader().getResourceAsStream(XML_FILE);
            if (is != null) {
                activities = (Activities) unmarshaller.unmarshal(is);
            } else {
                activities = new Activities();
            }
        } catch (JAXBException e) {
            e.printStackTrace();
            activities = new Activities();
        }
    }

    private void saveToXml() {
        try {
            Marshaller marshaller = context.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

            // Get the resource URL and save to file
            java.net.URL resource = getClass().getClassLoader().getResource(XML_FILE);
            if (resource != null) {
                File file = new File(resource.toURI());
                marshaller.marshal(activities, new FileOutputStream(file));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Activity> findAll() {
        if (activities == null || activities.getActivities() == null) {
            return new ArrayList<>();
        }
        return new ArrayList<>(activities.getActivities());
    }

    public Optional<Activity> findById(Long id) {
        return findAll().stream()
                .filter(a -> a.getId().equals(id))
                .findFirst();
    }

    public List<Activity> findByCity(String city) {
        return findAll().stream()
                .filter(a -> a.getCity().equalsIgnoreCase(city))
                .collect(Collectors.toList());
    }

    public List<Activity> findByType(String type) {
        return findAll().stream()
                .filter(a -> a.getType().equalsIgnoreCase(type))
                .collect(Collectors.toList());
    }

    public List<Activity> findByCityAndTypes(String city, List<String> types) {
        return findAll().stream()
                .filter(a -> a.getCity().equalsIgnoreCase(city))
                .filter(a -> types.contains(a.getType().toLowerCase()))
                .collect(Collectors.toList());
    }

    public List<Activity> findByCityAndBudget(String city, double maxCost) {
        return findAll().stream()
                .filter(a -> a.getCity().equalsIgnoreCase(city))
                .filter(a -> a.getCost() <= maxCost)
                .collect(Collectors.toList());
    }

    public Activity save(Activity activity) {
        if (activity.getId() == null) {
            // Generate new ID
            Long maxId = findAll().stream()
                    .mapToLong(Activity::getId)
                    .max()
                    .orElse(0L);
            activity.setId(maxId + 1);
        } else {
            // Remove existing if updating
            activities.getActivities().removeIf(a -> a.getId().equals(activity.getId()));
        }
        activities.addActivity(activity);
        saveToXml();
        return activity;
    }

    public void deleteById(Long id) {
        activities.getActivities().removeIf(a -> a.getId().equals(id));
        saveToXml();
    }

    public List<String> findDistinctTypes() {
        return findAll().stream()
                .map(Activity::getType)
                .distinct()
                .collect(Collectors.toList());
    }

    public List<String> findDistinctTypesByCity(String city) {
        return findByCity(city).stream()
                .map(Activity::getType)
                .distinct()
                .collect(Collectors.toList());
    }
}
