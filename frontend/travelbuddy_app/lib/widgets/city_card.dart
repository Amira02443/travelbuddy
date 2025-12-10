import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city.dart';

/// A beautiful card widget to display a city destination
class CityCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final int index;

  const CityCard({
    super.key,
    required this.city,
    required this.onTap,
    this.index = 0,
  });

  // Gradient colors for different cities
  static const List<List<Color>> _gradientColors = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Indigo -> Purple
    [Color(0xFFF59E0B), Color(0xFFEF4444)], // Amber -> Red
    [Color(0xFF10B981), Color(0xFF059669)], // Emerald -> Green
    [Color(0xFFEC4899), Color(0xFFF43F5E)], // Pink -> Rose
    [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Blue -> Indigo
    [Color(0xFF14B8A6), Color(0xFF0891B2)], // Teal -> Cyan
  ];

  // City emoji icons
  static const Map<String, String> _cityIcons = {
    'Paris': '🗼',
    'Rome': '🏛️',
    'Barcelona': '🏖️',
    'Marrakech': '🕌',
    'London': '🎡',
    'New York': '🗽',
    'Tokyo': '🗾',
    'Dubai': '🏙️',
  };

  @override
  Widget build(BuildContext context) {
    final colorPair = _gradientColors[index % _gradientColors.length];
    final cityIcon = _cityIcons[city.name] ?? '✈️';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colorPair,
          ),
          boxShadow: [
            BoxShadow(
              color: colorPair[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Opacity(
                  opacity: 0.1,
                  child: CustomPaint(
                    painter: _PatternPainter(),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cityIcon,
                        style: const TextStyle(fontSize: 32),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  // Bottom section with city info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          city.country,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        city.name,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (city.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          city.description!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for subtle pattern background
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    const spacing = 20.0;
    for (double i = 0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(0, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
