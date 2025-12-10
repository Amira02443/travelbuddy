package com.travelbuddy.repository;

import com.travelbuddy.model.Users;
import com.travelbuddy.model.User;
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

/**
 * Repository for User entities using XML as storage.
 */
@ApplicationScoped
public class UserRepository {

    private static UserRepository instance;

    public static synchronized UserRepository getInstance() {
        if (instance == null) {
            instance = new UserRepository();
            instance.init();
        }
        return instance;
    }

    private static final String XML_FILE = "data/users.xml";
    private Users users;
    private JAXBContext context;

    public void init() {
        try {
            context = JAXBContext.newInstance(Users.class);
            loadFromXml();
        } catch (JAXBException e) {
            e.printStackTrace();
            users = new Users();
        }
    }

    private void loadFromXml() {
        try {
            Unmarshaller unmarshaller = context.createUnmarshaller();
            InputStream is = getClass().getClassLoader().getResourceAsStream(XML_FILE);
            if (is != null) {
                users = (Users) unmarshaller.unmarshal(is);
            } else {
                users = new Users();
            }
        } catch (JAXBException e) {
            e.printStackTrace();
            users = new Users();
        }
    }

    private void saveToXml() {
        try {
            Marshaller marshaller = context.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

            java.net.URL resource = getClass().getClassLoader().getResource(XML_FILE);
            if (resource != null) {
                File file = new File(resource.toURI());
                marshaller.marshal(users, new FileOutputStream(file));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<User> findAll() {
        if (users == null || users.getUsers() == null) {
            return new ArrayList<>();
        }
        return new ArrayList<>(users.getUsers());
    }

    public Optional<User> findById(Long id) {
        return findAll().stream()
                .filter(u -> u.getId().equals(id))
                .findFirst();
    }

    public Optional<User> findByUsername(String username) {
        return findAll().stream()
                .filter(u -> u.getUsername().equalsIgnoreCase(username))
                .findFirst();
    }

    public Optional<User> findByEmail(String email) {
        return findAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email))
                .findFirst();
    }

    public User save(User user) {
        if (user.getId() == null) {
            Long maxId = findAll().stream()
                    .mapToLong(User::getId)
                    .max()
                    .orElse(0L);
            user.setId(maxId + 1);
            user.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
        } else {
            users.getUsers().removeIf(u -> u.getId().equals(user.getId()));
        }
        users.addUser(user);
        saveToXml();
        return user;
    }

    public void deleteById(Long id) {
        users.getUsers().removeIf(u -> u.getId().equals(id));
        saveToXml();
    }

    public boolean existsByUsername(String username) {
        return findByUsername(username).isPresent();
    }

    public boolean existsByEmail(String email) {
        return findByEmail(email).isPresent();
    }
}
