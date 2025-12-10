package com.travelbuddy.repository;

import com.travelbuddy.model.Cities;
import com.travelbuddy.model.City;
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

/**
 * Repository for City entities using XML as storage.
 */
@ApplicationScoped
public class CityRepository {

    private static CityRepository instance;

    public static synchronized CityRepository getInstance() {
        if (instance == null) {
            instance = new CityRepository();
            instance.init();
        }
        return instance;
    }

    private static final String XML_FILE = "data/cities.xml";
    private Cities cities;
    private JAXBContext context;

    public void init() {
        try {
            context = JAXBContext.newInstance(Cities.class);
            loadFromXml();
        } catch (JAXBException e) {
            e.printStackTrace();
            cities = new Cities();
        }
    }

    private void loadFromXml() {
        try {
            Unmarshaller unmarshaller = context.createUnmarshaller();
            InputStream is = getClass().getClassLoader().getResourceAsStream(XML_FILE);
            if (is != null) {
                cities = (Cities) unmarshaller.unmarshal(is);
            } else {
                cities = new Cities();
            }
        } catch (JAXBException e) {
            e.printStackTrace();
            cities = new Cities();
        }
    }

    private void saveToXml() {
        try {
            Marshaller marshaller = context.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

            java.net.URL resource = getClass().getClassLoader().getResource(XML_FILE);
            if (resource != null) {
                File file = new File(resource.toURI());
                marshaller.marshal(cities, new FileOutputStream(file));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<City> findAll() {
        if (cities == null || cities.getCities() == null) {
            return new ArrayList<>();
        }
        return new ArrayList<>(cities.getCities());
    }

    public Optional<City> findById(Long id) {
        return findAll().stream()
                .filter(c -> c.getId().equals(id))
                .findFirst();
    }

    public Optional<City> findByName(String name) {
        return findAll().stream()
                .filter(c -> c.getName().equalsIgnoreCase(name))
                .findFirst();
    }

    public City save(City city) {
        if (city.getId() == null) {
            Long maxId = findAll().stream()
                    .mapToLong(City::getId)
                    .max()
                    .orElse(0L);
            city.setId(maxId + 1);
        } else {
            cities.getCities().removeIf(c -> c.getId().equals(city.getId()));
        }
        cities.addCity(city);
        saveToXml();
        return city;
    }

    public void deleteById(Long id) {
        cities.getCities().removeIf(c -> c.getId().equals(id));
        saveToXml();
    }
}
