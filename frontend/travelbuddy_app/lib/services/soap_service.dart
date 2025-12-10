import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/itinerary.dart';
import '../utils/constants.dart';

/// SOAP Service for itinerary building
class SoapService {
  final String soapUrl = AppConstants.soapUrl;

  /// Build itinerary using SOAP service
  Future<Itinerary> buildItinerary(ItineraryRequest request) async {
    try {
      final soapEnvelope = request.toSoapXml();

      final response = await http.post(
        Uri.parse(soapUrl),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': '"buildItinerary"',
        },
        body: soapEnvelope,
      );

      if (response.statusCode == 200) {
        return _parseItineraryResponse(response.body);
      } else {
        return Itinerary.error('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('SOAP Error: $e');
      return Itinerary.error('Connection error: $e');
    }
  }

  /// Get activity types for a city using SOAP service
  Future<List<String>> getActivityTypes(String city) async {
    try {
      final soapEnvelope = '''
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                  xmlns:soap="http://soap.travelbuddy.com/">
  <soapenv:Header/>
  <soapenv:Body>
    <soap:getActivityTypes>
      <city>$city</city>
    </soap:getActivityTypes>
  </soapenv:Body>
</soapenv:Envelope>
''';

      final response = await http.post(
        Uri.parse(soapUrl),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': '"getActivityTypes"',
        },
        body: soapEnvelope,
      );

      if (response.statusCode == 200) {
        return _parseActivityTypesResponse(response.body);
      }
      return [];
    } catch (e) {
      print('SOAP Error getting activity types: $e');
      return [];
    }
  }

  /// Parse SOAP response for itinerary
  Itinerary _parseItineraryResponse(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);

      // Find the itineraryResponse element
      final responseElement =
          document.findAllElements('itineraryResponse').firstOrNull ??
              document.findAllElements('ns2:itineraryResponse').firstOrNull;

      if (responseElement == null) {
        return Itinerary.error('Invalid SOAP response');
      }

      final success = _getElementText(responseElement, 'success') == 'true';
      final message = _getElementText(responseElement, 'message');

      if (!success) {
        return Itinerary.error(message ?? 'Unknown error');
      }

      final city = _getElementText(responseElement, 'city');
      final totalCost = double.tryParse(
              _getElementText(responseElement, 'totalCost') ?? '0') ??
          0;
      final remainingBudget = double.tryParse(
              _getElementText(responseElement, 'remainingBudget') ?? '0') ??
          0;
      final totalDays =
          int.tryParse(_getElementText(responseElement, 'totalDays') ?? '0') ??
              0;
      final totalActivities = int.tryParse(
              _getElementText(responseElement, 'totalActivities') ?? '0') ??
          0;

      // Parse days
      final daysElement = responseElement.findElements('days').firstOrNull;
      final days = <ItineraryDay>[];

      if (daysElement != null) {
        for (final dayElement in daysElement.findElements('day')) {
          days.add(_parseDayElement(dayElement));
        }
      }

      return Itinerary(
        success: true,
        message: message,
        city: city,
        totalCost: totalCost,
        remainingBudget: remainingBudget,
        totalDays: totalDays,
        totalActivities: totalActivities,
        days: days,
      );
    } catch (e) {
      print('Error parsing SOAP response: $e');
      return Itinerary.error('Error parsing response: $e');
    }
  }

  ItineraryDay _parseDayElement(XmlElement dayElement) {
    final dayNumber = int.tryParse(dayElement.getAttribute('number') ??
            _getElementText(dayElement, 'dayNumber') ??
            '1') ??
        1;
    final date =
        dayElement.getAttribute('date') ?? _getElementText(dayElement, 'date');
    final dayCost =
        double.tryParse(_getElementText(dayElement, 'dayCost') ?? '0') ?? 0;

    final activities = <ScheduledActivity>[];
    final activitiesElement = dayElement.findElements('activities').firstOrNull;

    if (activitiesElement != null) {
      for (final actElement in activitiesElement.findElements('activity')) {
        activities.add(_parseActivityElement(actElement));
      }
    }

    return ItineraryDay(
      dayNumber: dayNumber,
      date: date,
      activities: activities,
      dayCost: dayCost,
    );
  }

  ScheduledActivity _parseActivityElement(XmlElement element) {
    return ScheduledActivity(
      activityId: int.tryParse(_getElementText(element, 'activityId') ?? '0'),
      name: _getElementText(element, 'name') ??
          element.getAttribute('name') ??
          '',
      startTime: _getElementText(element, 'startTime') ??
          element.getAttribute('start') ??
          '',
      endTime: _getElementText(element, 'endTime') ??
          element.getAttribute('end') ??
          '',
      cost: double.tryParse(_getElementText(element, 'cost') ??
              element.getAttribute('cost') ??
              '0') ??
          0,
      type: _getElementText(element, 'type') ?? '',
      description: _getElementText(element, 'description'),
    );
  }

  List<String> _parseActivityTypesResponse(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      final types = <String>[];

      for (final element in document.findAllElements('activityTypes')) {
        types.add(element.innerText);
      }

      return types;
    } catch (e) {
      print('Error parsing activity types: $e');
      return [];
    }
  }

  String? _getElementText(XmlElement parent, String name) {
    final element = parent.findElements(name).firstOrNull ??
        parent.findElements('ns2:$name').firstOrNull;
    return element?.innerText;
  }
}
