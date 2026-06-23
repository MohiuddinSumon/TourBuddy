/// A structured travel guide for a single destination.
class TravelGuide {
  final String destination;
  final List<String> thingsToDo;
  final List<String> scamsToAvoid;
  final List<String> localTips;
  final List<String> foodToTry;
  final List<String> gettingAround;

  const TravelGuide({
    required this.destination,
    required this.thingsToDo,
    required this.scamsToAvoid,
    required this.localTips,
    required this.foodToTry,
    required this.gettingAround,
  });

  /// Plain-text version used by the "Copy Guide" button.
  String toShareText() {
    final buffer = StringBuffer()
      ..writeln('TourBuddy — $destination Travel Guide')
      ..writeln();

    void section(String title, List<String> items) {
      buffer.writeln(title);
      for (final item in items) {
        buffer.writeln('• $item');
      }
      buffer.writeln();
    }

    section('Things to Do', thingsToDo);
    section('Scams to Avoid', scamsToAvoid);
    section('Local Tips', localTips);
    section('Food to Try', foodToTry);
    section('Getting Around', gettingAround);

    return buffer.toString().trim();
  }
}
