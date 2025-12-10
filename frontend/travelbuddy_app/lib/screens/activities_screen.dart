import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/activity.dart';
import '../services/api_service.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final ApiService _apiService = ApiService();
  List<Activity> _activities = [];
  bool _isLoading = true;
  String? _selectedCity;
  String? _selectedType;

  final List<String> _cities = ['Paris', 'Rome', 'Barcelona', 'Marrakech'];
  final List<String> _types = [
    'landmark',
    'museum',
    'restaurant',
    'nature',
    'shopping',
    'nightlife',
    'experience'
  ];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);
    try {
      List<Activity> activities;
      if (_selectedCity != null) {
        activities = await _apiService.getActivitiesByCity(_selectedCity!);
      } else if (_selectedType != null) {
        activities = await _apiService.getActivitiesByType(_selectedType!);
      } else {
        activities = await _apiService.getActivities();
      }
      setState(() {
        _activities = activities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Show demo data on error
      setState(() {
        _activities = [
          Activity(
              id: 1,
              name: 'Tour Eiffel',
              city: 'Paris',
              type: 'landmark',
              duration: 3,
              cost: 26.80,
              rating: 4.8,
              description: 'La tour emblématique de Paris',
              timeSlot: 'morning'),
          Activity(
              id: 2,
              name: 'Musée du Louvre',
              city: 'Paris',
              type: 'museum',
              duration: 4,
              cost: 17.00,
              rating: 4.9,
              description: 'Le plus grand musée d\'art au monde',
              timeSlot: 'morning'),
          Activity(
              id: 3,
              name: 'Colisée',
              city: 'Rome',
              type: 'landmark',
              duration: 3,
              cost: 18.00,
              rating: 4.9,
              description: 'L\'amphithéâtre antique emblématique',
              timeSlot: 'morning'),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Activités'),
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(),

          // Activities list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _activities.isEmpty
                    ? _buildEmptyState()
                    : _buildActivityList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: InputDecoration(
                labelText: 'Ville',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Toutes')),
                ..._cities.map(
                    (city) => DropdownMenuItem(value: city, child: Text(city))),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                  _selectedType = null;
                });
                _loadActivities();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Tous')),
                ..._types.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getTypeLabel(type)),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                  _selectedCity = null;
                });
                _loadActivities();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    const labels = {
      'landmark': 'Monuments',
      'museum': 'Musées',
      'restaurant': 'Restaurants',
      'nature': 'Nature',
      'shopping': 'Shopping',
      'nightlife': 'Vie nocturne',
      'experience': 'Expériences',
    };
    return labels[type] ?? type;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            'Aucune activité trouvée',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _activities.length,
      itemBuilder: (context, index) => _buildActivityCard(_activities[index]),
    );
  }

  Widget _buildActivityCard(Activity activity) {
    final typeColors = {
      'landmark': Colors.orange,
      'museum': Colors.purple,
      'restaurant': Colors.red,
      'nature': Colors.green,
      'shopping': Colors.pink,
      'nightlife': Colors.indigo,
      'experience': Colors.teal,
    };
    final color = typeColors[activity.type] ?? Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showActivityDetails(activity),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _getTypeEmoji(activity.type),
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          activity.city,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${activity.duration}h',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getTypeLabel(activity.type),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              activity.rating.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Price
              Column(
                children: [
                  Text(
                    '${activity.cost.toStringAsFixed(0)}€',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTypeEmoji(String type) {
    const emojis = {
      'landmark': '🏛️',
      'museum': '🖼️',
      'restaurant': '🍽️',
      'nature': '🌿',
      'shopping': '🛍️',
      'nightlife': '🌙',
      'experience': '✨',
    };
    return emojis[type] ?? '📍';
  }

  void _showActivityDetails(Activity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              activity.name,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 4),
                Text(activity.city, style: GoogleFonts.inter(fontSize: 16)),
                const SizedBox(width: 16),
                const Icon(Icons.star, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${activity.rating}',
                    style: GoogleFonts.inter(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              activity.description,
              style: GoogleFonts.inter(fontSize: 15, color: Colors.grey[600]),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Durée',
                          style: GoogleFonts.inter(color: Colors.grey)),
                      Text('${activity.duration} heures',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prix',
                          style: GoogleFonts.inter(color: Colors.grey)),
                      Text('${activity.cost.toStringAsFixed(2)}€',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
