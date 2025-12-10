import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary.dart';

/// A timeline widget to display a day's activities
class DayTimeline extends StatelessWidget {
  final ItineraryDay day;
  final String currencySymbol;
  final Color? primaryColor;

  const DayTimeline({
    super.key,
    required this.day,
    this.currencySymbol = '€',
    this.primaryColor,
  });

  // Time slot colors
  static const Map<String, Color> _timeSlotColors = {
    'morning': Color(0xFFFF9800), // Orange
    'afternoon': Color(0xFF2196F3), // Blue
    'evening': Color(0xFF9C27B0), // Purple
  };

  // Time slot icons
  static const Map<String, IconData> _timeSlotIcons = {
    'morning': Icons.wb_sunny,
    'afternoon': Icons.wb_cloudy,
    'evening': Icons.nights_stay,
  };

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          _buildDayHeader(context, color),

          // Activities timeline
          Padding(
            padding: const EdgeInsets.all(16),
            child: day.activities.isEmpty
                ? _buildEmptyState()
                : _buildTimeline(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${day.dayNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jour ${day.dayNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (day.date != null)
                    Text(
                      day.date!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.euro, size: 14, color: color),
                const SizedBox(width: 4),
                Text(
                  '${day.dayCost.toStringAsFixed(2)} $currencySymbol',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('🏖️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              'Journée libre',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return Column(
      children: List.generate(day.activities.length, (index) {
        final activity = day.activities[index];
        final isLast = index == day.activities.length - 1;
        final timeSlot = _getTimeSlot(index);
        final color = _timeSlotColors[timeSlot] ?? Colors.grey;

        return _buildTimelineItem(
          context,
          activity,
          color,
          timeSlot,
          isLast,
        );
      }),
    );
  }

  String _getTimeSlot(int index) {
    if (index == 0) return 'morning';
    if (index == 1) return 'afternoon';
    return 'evening';
  }

  Widget _buildTimelineItem(
    BuildContext context,
    ScheduledActivity activity,
    Color color,
    String timeSlot,
    bool isLast,
  ) {
    final icon = _timeSlotIcons[timeSlot] ?? Icons.access_time;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 10, color: Colors.white),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey[300],
                    ),
                  ),
              ],
            ),
          ),

          // Activity content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.schedule, size: 12, color: color),
                              const SizedBox(width: 4),
                              Text(
                                activity.timeRange,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${activity.cost.toStringAsFixed(2)} $currencySymbol',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Activity name
                    Text(
                      activity.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Description
                    if (activity.description != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        activity.description!,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
