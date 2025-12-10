import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city.dart';
import '../models/itinerary.dart';
import '../services/soap_service.dart';
import '../utils/constants.dart';
import 'itinerary_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  final City city;

  const TripPlannerScreen({super.key, required this.city});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final SoapService _soapService = SoapService();

  double _budget = 500;
  int _duration = 3;
  String _preference = 'balanced';
  final Set<String> _selectedTypes = {'landmark', 'museum', 'restaurant'};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with city info
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.city.name,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    '✈️',
                    style: GoogleFonts.inter(fontSize: 60),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Budget Section
                _buildSectionTitle('💰 Budget',
                    '${_budget.toInt()} ${widget.city.currencySymbol}'),
                const SizedBox(height: 16),
                _buildBudgetSlider(),
                const SizedBox(height: 32),

                // Duration Section
                _buildSectionTitle(
                    '📅 Durée', '$_duration jour${_duration > 1 ? 's' : ''}'),
                const SizedBox(height: 16),
                _buildDurationSelector(),
                const SizedBox(height: 32),

                // Preference Section
                _buildSectionTitle('⚡ Rythme', ''),
                const SizedBox(height: 16),
                _buildPreferenceSelector(),
                const SizedBox(height: 32),

                // Activity Types Section
                _buildSectionTitle('🎯 Types d\'activités', ''),
                const SizedBox(height: 16),
                _buildActivityTypeChips(),
                const SizedBox(height: 48),

                // Generate Button
                _buildGenerateButton(),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (value.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBudgetSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            value: _budget,
            min: AppConstants.minBudget,
            max: AppConstants.maxBudget,
            divisions: 100,
            onChanged: (value) {
              setState(() {
                _budget = value;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0 ${widget.city.currencySymbol}',
                style: GoogleFonts.inter(color: Colors.grey)),
            Text('5000 ${widget.city.currencySymbol}',
                style: GoogleFonts.inter(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDurationButton(Icons.remove, () {
          if (_duration > AppConstants.minDuration) {
            setState(() => _duration--);
          }
        }),
        const SizedBox(width: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$_duration',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 24),
        _buildDurationButton(Icons.add, () {
          if (_duration < AppConstants.maxDuration) {
            setState(() => _duration++);
          }
        }),
      ],
    );
  }

  Widget _buildDurationButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Icon(icon, size: 28),
        ),
      ),
    );
  }

  Widget _buildPreferenceSelector() {
    return Row(
      children: AppConstants.preferences.map((pref) {
        final isSelected = _preference == pref;
        final label = AppConstants.preferenceLabels[pref] ?? pref;
        final icon =
            pref == 'relaxed' ? '🧘' : (pref == 'balanced' ? '⚖️' : '🏃');

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () => setState(() => _preference = pref),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityTypeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.activityTypes.map((type) {
        final isSelected = _selectedTypes.contains(type);
        final label = AppConstants.activityTypeLabels[type] ?? type;
        final icons = {
          'landmark': '🏛️',
          'museum': '🖼️',
          'restaurant': '🍽️',
          'nature': '🌿',
          'shopping': '🛍️',
          'nightlife': '🌙',
          'experience': '✨',
        };

        return FilterChip(
          label: Text('${icons[type] ?? ''} $label'),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTypes.add(type);
              } else {
                _selectedTypes.remove(type);
              }
            });
          },
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );
      }).toList(),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            _selectedTypes.isEmpty || _isLoading ? null : _generateItinerary,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Générer mon itinéraire 🚀',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _generateItinerary() async {
    setState(() => _isLoading = true);

    try {
      final request = ItineraryRequest(
        city: widget.city.name,
        budget: _budget,
        duration: _duration,
        activityTypes: _selectedTypes.toList(),
        preference: _preference,
      );

      final itinerary = await _soapService.buildItinerary(request);

      if (mounted) {
        if (itinerary.success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItineraryScreen(
                itinerary: itinerary,
                city: widget.city,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(itinerary.message ?? 'Erreur lors de la génération'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
