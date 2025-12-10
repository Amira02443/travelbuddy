package com.travelbuddy.soap;

import com.travelbuddy.model.Itinerary;
import com.travelbuddy.model.ItineraryRequest;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import jakarta.jws.WebResult;
import jakarta.jws.WebService;
import jakarta.jws.soap.SOAPBinding;
import java.util.List;

/**
 * SOAP Web Service interface for itinerary building.
 */
@WebService(name = "ItineraryWebService", targetNamespace = "http://soap.travelbuddy.com/")
@SOAPBinding(style = SOAPBinding.Style.DOCUMENT)
public interface ItineraryWebService {

    /**
     * Build an itinerary based on user preferences.
     * This is the main SOAP operation.
     * 
     * @param request The itinerary request containing city, budget, duration, etc.
     * @return The generated itinerary with scheduled activities
     */
    @WebMethod(operationName = "buildItinerary")
    @WebResult(name = "itineraryResponse")
    Itinerary buildItinerary(
            @WebParam(name = "itineraryRequest") ItineraryRequest request);

    /**
     * Get available activity types for a city.
     * 
     * @param city The city name (optional, returns all types if null)
     * @return List of activity type names
     */
    @WebMethod(operationName = "getActivityTypes")
    @WebResult(name = "activityTypes")
    List<String> getActivityTypes(
            @WebParam(name = "city") String city);
}
