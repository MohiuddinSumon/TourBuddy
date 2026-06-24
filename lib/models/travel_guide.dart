/// A single tip in a travel guide section — a short headline plus a 1–2
/// sentence practical detail. Mirrors the bundled `guides-bundle.json` schema.
class GuideItem {
  final String title;
  final String description;

  const GuideItem({required this.title, required this.description});

  factory GuideItem.fromJson(Map<String, dynamic> json) => GuideItem(
        title: (json['title'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
      );
}

/// A structured travel guide for a single destination.
class TravelGuide {
  final String destination;
  final List<GuideItem> topThingsToDo;
  final List<GuideItem> scamsToAvoid;
  final List<GuideItem> localTips;
  final List<GuideItem> foodToTry;
  final List<GuideItem> gettingAround;

  const TravelGuide({
    required this.destination,
    required this.topThingsToDo,
    required this.scamsToAvoid,
    required this.localTips,
    required this.foodToTry,
    required this.gettingAround,
  });

  factory TravelGuide.fromJson(Map<String, dynamic> json, {String? fallbackDestination}) {
    List<GuideItem> items(dynamic raw) {
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((m) => GuideItem.fromJson(m.cast<String, dynamic>()))
          .where((g) => g.title.isNotEmpty || g.description.isNotEmpty)
          .toList(growable: false);
    }

    return TravelGuide(
      destination: (json['destination'] ?? fallbackDestination ?? '').toString(),
      topThingsToDo: items(json['topThingsToDo']),
      scamsToAvoid: items(json['scamsToAvoid']),
      localTips: items(json['localTips']),
      foodToTry: items(json['foodToTry']),
      gettingAround: items(json['gettingAround']),
    );
  }

  /// Plain-text version used by the "Copy Guide" button.
  String toShareText() {
    final buffer = StringBuffer()
      ..writeln('TourBuddy — $destination Travel Guide')
      ..writeln();

    void section(String title, List<GuideItem> items) {
      buffer.writeln(title);
      for (final item in items) {
        if (item.description.isEmpty) {
          buffer.writeln('• ${item.title}');
        } else {
          buffer.writeln('• ${item.title} — ${item.description}');
        }
      }
      buffer.writeln();
    }

    section('Things to Do', topThingsToDo);
    section('Scams to Avoid', scamsToAvoid);
    section('Local Tips', localTips);
    section('Food to Try', foodToTry);
    section('Getting Around', gettingAround);

    return buffer.toString().trim();
  }
}
