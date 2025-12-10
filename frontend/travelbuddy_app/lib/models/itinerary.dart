/// Itinerary models for SOAP service responses

class ScheduledActivity {
  final int? activityId;
  final String name;
  final String startTime;
  final String endTime;
  final double cost;
  final String type;
  final String? description;

  ScheduledActivity({
    this.activityId,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.cost,
    required this.type,
    this.description,
  });

  factory ScheduledActivity.fromJson(Map<String, dynamic> json) {
    return ScheduledActivity(
      activityId: json['activityId'],
      name: json['name'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      cost: (json['cost'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      description: json['description'],
    );
  }

  String get timeRange => '$startTime - $endTime';
}

class ItineraryDay {
  final int dayNumber;
  final String? date;
  final List<ScheduledActivity> activities;
  final double dayCost;

  ItineraryDay({
    required this.dayNumber,
    this.date,
    required this.activities,
    required this.dayCost,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      dayNumber: json['dayNumber'] ?? 1,
      date: json['date'],
      activities: (json['activities'] as List<dynamic>?)
              ?.map((a) => ScheduledActivity.fromJson(a))
              .toList() ??
          [],
      dayCost: (json['dayCost'] ?? 0).toDouble(),
    );
  }

  String get displayTitle => 'Jour $dayNumber${date != null ? ' - $date' : ''}';
}

class Itinerary {
  final bool success;
  final String? message;
  final String? city;
  final double totalCost;
  final double remainingBudget;
  final int totalDays;
  final int totalActivities;
  final List<ItineraryDay> days;

  Itinerary({
    required this.success,
    this.message,
    this.city,
    this.totalCost = 0,
    this.remainingBudget = 0,
    this.totalDays = 0,
    this.totalActivities = 0,
    this.days = const [],
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      success: json['success'] ?? false,
      message: json['message'],
      city: json['city'],
      totalCost: (json['totalCost'] ?? 0).toDouble(),
      remainingBudget: (json['remainingBudget'] ?? 0).toDouble(),
      totalDays: json['totalDays'] ?? 0,
      totalActivities: json['totalActivities'] ?? 0,
      days: (json['days'] as List<dynamic>?)
              ?.map((d) => ItineraryDay.fromJson(d))
              .toList() ??
          [],
    );
  }

  factory Itinerary.error(String message) {
    return Itinerary(success: false, message: message);
  }
}

class ItineraryRequest {
  final String city;
  final double budget;
  final int duration;
  final List<String> activityTypes;
  final String preference;

  ItineraryRequest({
    required this.city,
    required this.budget,
    required this.duration,
    required this.activityTypes,
    required this.preference,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'budget': budget,
      'duration': duration,
      'activityTypes': activityTypes,
      'preference': preference,
    };
  }

  /// Convert to SOAP XML request
  String toSoapXml() {
    final typesXml = activityTypes.map((t) => '<type>$t</type>').join('\n');
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                  xmlns:soap="http://soap.travelbuddy.com/">
  <soapenv:Header/>
  <soapenv:Body>
    <soap:buildItinerary>
      <itineraryRequest>
        <city>$city</city>
        <budget>$budget</budget>
        <duration>$duration</duration>
        <activityTypes>
          $typesXml
        </activityTypes>
        <preference>$preference</preference>
      </itineraryRequest>
    </soap:buildItinerary>
  </soapenv:Body>
</soapenv:Envelope>
''';
  }
}
