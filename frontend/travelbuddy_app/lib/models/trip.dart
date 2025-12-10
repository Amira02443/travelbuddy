/// Trip model class
class Trip {
  final int? id;
  final int? userId;
  final String city;
  final String title;
  final String? startDate;
  final String? endDate;
  final int duration;
  final double budget;
  final double? totalCost;
  final String status;
  final String? createdAt;
  final List<int> activityIds;

  Trip({
    this.id,
    this.userId,
    required this.city,
    required this.title,
    this.startDate,
    this.endDate,
    required this.duration,
    required this.budget,
    this.totalCost,
    this.status = 'planned',
    this.createdAt,
    this.activityIds = const [],
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['userId'],
      city: json['city'] ?? '',
      title: json['title'] ?? '',
      startDate: json['startDate'],
      endDate: json['endDate'],
      duration: json['duration'] ?? 1,
      budget: (json['budget'] ?? 0).toDouble(),
      totalCost: json['totalCost']?.toDouble(),
      status: json['status'] ?? 'planned',
      createdAt: json['createdAt'],
      activityIds: (json['activityIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'city': city,
      'title': title,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      'duration': duration,
      'budget': budget,
      if (totalCost != null) 'totalCost': totalCost,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt,
      'activityIds': activityIds,
    };
  }

  String get statusLabel {
    const labels = {
      'planned': '📅 Planifié',
      'ongoing': '✈️ En cours',
      'completed': '✅ Terminé',
    };
    return labels[status] ?? status;
  }
}
