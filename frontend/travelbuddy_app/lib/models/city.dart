/// City model class
class City {
  final int id;
  final String name;
  final String country;
  final String currency;
  final String? image;
  final String? description;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.currency,
    this.image,
    this.description,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      currency: json['currency'] ?? 'EUR',
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'currency': currency,
      'image': image,
      'description': description,
    };
  }

  String get displayName => '$name, $country';

  String get currencySymbol {
    const symbols = {
      'EUR': '€',
      'USD': '\$',
      'GBP': '£',
      'MAD': 'DH',
    };
    return symbols[currency] ?? currency;
  }
}
