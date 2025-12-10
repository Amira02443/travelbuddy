package com.travelbuddy.soap;

import com.travelbuddy.model.Itinerary;
import com.travelbuddy.model.ItineraryRequest;
import com.travelbuddy.service.ItineraryService;
import jakarta.inject.Inject;
import jakarta.jws.WebService;
import java.util.List;

/**
 * SOAP Web Service implementation for itinerary building.
 */
@WebService(serviceName = "ItineraryService", portName = "ItineraryPort", endpointInterface = "com.travelbuddy.soap.ItineraryWebService", targetNamespace = "http://soap.travelbuddy.com/")
public class ItineraryWebServiceImpl implements ItineraryWebService {

    private ItineraryService itineraryService = ItineraryService.getInstance();

    @Override
    public Itinerary buildItinerary(ItineraryRequest request) {
        System.out.println("SOAP Request received: " + request);

        try {
            Itinerary result = itineraryService.buildItinerary(request);
            System.out.println("SOAP Response: " + result);
            return result;
        } catch (Exception e) {
            System.err.println("Error building itinerary: " + e.getMessage());
            return new Itinerary(false, "Error: " + e.getMessage());
        }
    }

    @Override
    public List<String> getActivityTypes(String city) {
        System.out.println("SOAP Request - getActivityTypes for city: " + city);
        return itineraryService.getActivityTypes(city);
    }
}
