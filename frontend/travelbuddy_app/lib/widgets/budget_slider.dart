import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A stylish budget slider widget with visual feedback
class BudgetSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String currencySymbol;
  final ValueChanged<double> onChanged;
  final int divisions;
  final Color? activeColor;

  const BudgetSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 5000,
    this.currencySymbol = '€',
    this.divisions = 100,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? Theme.of(context).colorScheme.primary;
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Budget display
        _buildBudgetDisplay(context, color),
        const SizedBox(height: 16),

        // Custom slider
        _buildSlider(context, color),
        const SizedBox(height: 8),

        // Min/Max labels
        _buildRangeLabels(),
        const SizedBox(height: 16),

        // Budget categories
        _buildBudgetCategories(context, percentage),
      ],
    );
  }

  Widget _buildBudgetDisplay(BuildContext context, Color color) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance_wallet, color: color, size: 28),
            const SizedBox(width: 12),
            Text(
              '${value.toInt()}',
              style: GoogleFonts.inter(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              currencySymbol,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context, Color color) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 10,
        activeTrackColor: color,
        inactiveTrackColor: color.withOpacity(0.15),
        thumbColor: Colors.white,
        thumbShape: _CustomThumbShape(color: color),
        overlayColor: color.withOpacity(0.2),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
        trackShape: _CustomTrackShape(),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRangeLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${min.toInt()} $currencySymbol',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          Text(
            '${max.toInt()} $currencySymbol',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCategories(BuildContext context, double percentage) {
    final categories = [
      _BudgetCategory('Économique', '💰', 0.0, 0.25, Colors.green),
      _BudgetCategory('Modéré', '💵', 0.25, 0.5, Colors.blue),
      _BudgetCategory('Confortable', '💎', 0.5, 0.75, Colors.purple),
      _BudgetCategory('Luxe', '👑', 0.75, 1.0, Colors.amber),
    ];

    final currentCategory = categories.firstWhere(
      (c) => percentage >= c.start && percentage <= c.end,
      orElse: () => categories.first,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: currentCategory.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: currentCategory.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentCategory.emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Text(
            currentCategory.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: currentCategory.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetCategory {
  final String label;
  final String emoji;
  final double start;
  final double end;
  final Color color;

  _BudgetCategory(this.label, this.emoji, this.start, this.end, this.color);
}

/// Custom thumb shape for the slider
class _CustomThumbShape extends SliderComponentShape {
  final Color color;

  const _CustomThumbShape({required this.color});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Outer shadow
    final shadowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, 14, shadowPaint);

    // White background
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 12, whitePaint);

    // Colored border
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, 10, borderPaint);

    // Inner dot
    final dotPaint = Paint()..color = color;
    canvas.drawCircle(center, 4, dotPaint);
  }
}

/// Custom track shape for rounded corners
class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 4;
    final trackLeft = offset.dx + 12;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width - 24;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
