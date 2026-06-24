import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/travel_guide.dart';

/// Generates travel guides.
///
/// Phase 1: lookup against the bundled `assets/guides-bundle.json` (105 cities).
/// Unknown destinations fall back to a generic templated guide.
///
/// Phase 2 will extend this with multi-provider live AI generation when the
/// user has supplied their own API key. Keep the `Future<TravelGuide>`
/// signature stable so screens don't change.
class GuideService {
  static const _bundlePath = 'assets/guides-bundle.json';
  static Map<String, TravelGuide>? _cache;
  static Future<Map<String, TravelGuide>>? _loading;

  Future<TravelGuide> generateGuide(String destination) async {
    final guides = await _loadBundle();
    final key = destination.trim().toLowerCase();
    final hit = guides[key];
    if (hit != null) {
      // Tiny artificial delay so the loading spinner is still visible.
      await Future.delayed(const Duration(milliseconds: 250));
      return hit;
    }
    await Future.delayed(const Duration(milliseconds: 900));
    return _genericGuide(destination.trim());
  }

  static Future<Map<String, TravelGuide>> _loadBundle() {
    if (_cache != null) return Future.value(_cache!);
    return _loading ??= rootBundle.loadString(_bundlePath).then((raw) {
      final Map<String, dynamic> decoded = json.decode(raw) as Map<String, dynamic>;
      final result = <String, TravelGuide>{};
      decoded.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          result[key.toLowerCase()] =
              TravelGuide.fromJson(value, fallbackDestination: key);
        }
      });
      _cache = result;
      return result;
    });
  }

  TravelGuide _genericGuide(String destination) {
    final place = _titleCase(destination);
    GuideItem g(String t, String d) => GuideItem(title: t, description: d);
    return TravelGuide(
      destination: place,
      topThingsToDo: [
        g('Walk the historic centre on foot',
            'Most highlights in $place are within a compact, walkable core — start here before booking taxis.'),
        g('Visit the top-rated museum or landmark',
            'Book a timed ticket online and arrive at opening to skip the longest queues.'),
        g('Find a viewpoint or rooftop bar',
            'A sunset view orients you to the city and is far cheaper than a sightseeing tour.'),
        g('Spend an evening at a popular local market',
            'Markets are where you eat best and meet locals — go hungry and bring small cash.'),
      ],
      scamsToAvoid: [
        g('Unmetered taxis',
            'Agree a price first or use a ride-hailing app; airport rides are the worst offenders.'),
        g('"Free" gifts on the street',
            'Bracelets, roses, or photos pushed into your hands always end with a demand for money.'),
        g('Overly friendly strangers',
            'If someone steers you to a specific shop, restaurant, or "show", walk away.'),
        g('Card-machine tricks',
            'Watch the screen before tapping — confirm the currency and amount, never let it leave your sight.'),
      ],
      localTips: [
        g('Carry small cash',
            'Many stalls and small cafes do not take cards; ATMs at banks have the best rates.'),
        g('Learn a few words of the local language',
            'A simple hello and thank-you visibly changes how you are treated.'),
        g('Visit popular spots at opening',
            'The first hour beats every tour group and is the best time for photos.'),
        g('Keep digital + paper copies of your ID',
            'Store photos in your phone and email; carry a paper copy separately from the original.'),
      ],
      foodToTry: [
        g('The signature street-food dish',
            'Look for the stand with the longest local queue — that is where it is best and freshest.'),
        g('A traditional sit-down meal',
            'Family-run places a few streets back from the main square beat anything on the tourist strip.'),
        g('Seasonal fruit or sweets from a market',
            'Cheap, memorable, and tells you what the region grows right now.'),
        g('A local drink the region is known for',
            'Coffee, tea, or a regional spirit — order what locals are drinking at the next table.'),
      ],
      gettingAround: [
        g('Use public transit for longer trips',
            'A metro or bus pass is dramatically cheaper than taxis and often faster in traffic.'),
        g('Walk between nearby sights',
            'Most city centres are compact; walking is the cheapest sightseeing there is.'),
        g('Use a trusted ride-hailing app',
            'App-based rides give you a fixed price, a record, and a way to report problems.'),
        g('Buy a multi-day transit pass',
            'If you are staying more than 2 days, the pass usually pays for itself by day two.'),
      ],
    );
  }

  static String _titleCase(String input) {
    if (input.isEmpty) return input;
    return input
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }
}
