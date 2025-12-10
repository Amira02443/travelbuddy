/// Activity model class
class Activity {
  final int id;
  final String name;
  final String city;
  final String type;
  final int duration;
  final double cost;
  final double rating;
  final String description;
  final String timeSlot;
  final String? image;

  Activity({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
    required this.duration,
    required this.cost,
    required this.rating,
    required this.description,
    required this.timeSlot,
    this.image,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      type: json['type'] ?? '',
      duration: json['duration'] ?? 0,
      cost: (json['cost'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      timeSlot: json['timeSlot'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'type': type,
      'duration': duration,
      'cost': cost,
      'rating': rating,
      'description': description,
      'timeSlot': timeSlot,
      'image': image,
    };
  }

  String get typeLabel {
    const labels = {
      'landmark': '🏛️ Monument',
      'museum': '🖼️ Musée',
      'restaurant': '🍽️ Restaurant',
      'nature': '🌿 Nature',
      'shopping': '🛍️ Shopping',
      'nightlife': '🌙 Vie nocturne',
      'experience': '✨ Expérience',
    };
    return labels[type] ?? type;
  }
}
