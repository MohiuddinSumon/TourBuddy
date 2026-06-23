import '../models/travel_guide.dart';

/// Generates travel guides.
///
/// For now this returns mock data so the app runs with no API key.
/// In Step 7 you replace the body of [generateGuide] with a real OpenAI
/// call — nothing else in the app needs to change.
class GuideService {
  Future<TravelGuide> generateGuide(String destination) async {
    // Simulate AI "thinking" time so the loading state is visible.
    await Future.delayed(const Duration(milliseconds: 900));

    final key = destination.trim().toLowerCase();
    return _mockGuides[key] ?? _genericGuide(destination.trim());
  }

  TravelGuide _genericGuide(String destination) {
    final place = _titleCase(destination);
    return TravelGuide(
      destination: place,
      thingsToDo: [
        'Walk the main old-town or historic district on foot.',
        'Visit the top-rated museum or landmark in $place.',
        'Find a viewpoint or park to see the city from above.',
        'Spend an evening at a popular local market.',
      ],
      scamsToAvoid: [
        'Taxis with no meter — agree a price first or use an app.',
        '"Free" bracelets, roses, or gifts handed to you on the street.',
        'Overly friendly strangers steering you to a specific shop.',
        'Card machines that hide the amount — always check before paying.',
      ],
      localTips: [
        'Carry small cash for stalls that do not take cards.',
        'Learn a few words of the local language — it goes a long way.',
        'Visit popular spots early to avoid crowds and queues.',
        'Keep a digital and paper copy of your ID and bookings.',
      ],
      foodToTry: [
        'The signature street-food dish locals queue for.',
        'A traditional sit-down meal at a family-run place.',
        'Seasonal fruit or sweets from the local market.',
        'A local drink or coffee the region is known for.',
      ],
      gettingAround: [
        'Use the metro or public transit for longer trips — it is cheapest.',
        'Walk between nearby sights; many centres are compact.',
        'Use a trusted ride-hailing app instead of street taxis.',
        'Buy a multi-day transit pass if you are staying a while.',
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

  static final Map<String, TravelGuide> _mockGuides = {
    'bali': const TravelGuide(
      destination: 'Bali',
      thingsToDo: [
        'Watch sunrise from a rice-terrace viewpoint in Tegallalang.',
        'See the sea temple at Tanah Lot at sunset.',
        'Take a day trip to the Nusa islands for snorkelling.',
        'Explore Ubud’s art markets and monkey forest.',
      ],
      scamsToAvoid: [
        'Money changers that short-change you — use authorised counters.',
        'Scooter "damage" claims — photograph the bike before renting.',
        'Inflated taxi fares — use Grab or Gojek where allowed.',
        'Temple "donations" demanded aggressively at the gate.',
      ],
      localTips: [
        'Dress modestly and wear a sarong at temples.',
        'Carry cash; many warungs (local eateries) are cash-only.',
        'Avoid tap water — drink sealed bottled water.',
        'Traffic is heavy; plan extra time for short distances.',
      ],
      foodToTry: [
        'Babi guling (Balinese roast pork).',
        'Nasi campur — rice with a mix of small dishes.',
        'Satay lilit — minced satay on lemongrass skewers.',
        'Fresh young coconut straight from the shell.',
      ],
      gettingAround: [
        'Rent a scooter only if you are confident riding.',
        'Use Grab or Gojek apps for cars and bikes.',
        'Hire a private driver for full-day island trips.',
        'Expect no real public transit — plan point to point.',
      ],
    ),
    'dubai': const TravelGuide(
      destination: 'Dubai',
      thingsToDo: [
        'Go up the Burj Khalifa observation deck.',
        'Wander old Al Fahidi and take an abra across the creek.',
        'Do a desert safari with dune driving at sunset.',
        'Visit the Dubai Mall fountains in the evening.',
      ],
      scamsToAvoid: [
        'Unofficial "guides" at souks who demand a tip after.',
        'Gold or souvenir prices with no tag — always bargain.',
        'Unlicensed taxis at the airport — use the official rank.',
        'Photos with "free" falcons or costumes that end in a fee.',
      ],
      localTips: [
        'Dress modestly in malls and public areas.',
        'The Metro is clean, cheap, and easy — buy a Nol card.',
        'Fridays start late — many places open after prayers.',
        'Everything is air-conditioned; carry a light layer.',
      ],
      foodToTry: [
        'Shawarma from a busy local stand.',
        'Machboos — spiced rice with meat or fish.',
        'Luqaimat — sweet fried dumplings with date syrup.',
        'Karak chai (strong sweet milk tea).',
      ],
      gettingAround: [
        'The Metro covers most tourist areas.',
        'Use Careem or Uber for door-to-door trips.',
        'Official cream taxis are metered and reliable.',
        'Avoid walking long distances in peak heat.',
      ],
    ),
    'paris': const TravelGuide(
      destination: 'Paris',
      thingsToDo: [
        'See the Eiffel Tower, then picnic on the Champ de Mars.',
        'Visit the Louvre early to beat the queues.',
        'Walk Montmartre and the steps by Sacré-Cœur.',
        'Stroll the Seine and browse the riverside book stalls.',
      ],
      scamsToAvoid: [
        'The "gold ring" found on the ground — keep walking.',
        'Petition or charity clipboard distraction thefts.',
        'Friendship-bracelet sellers near Sacré-Cœur.',
        'Pickpockets on Metro line 1 and at major sights.',
      ],
      localTips: [
        'Greet shopkeepers with "Bonjour" before asking anything.',
        'Buy a carnet or Navigo pass for the Metro.',
        'Many museums are free on the first Sunday of the month.',
        'Keep bags zipped and in front on crowded trains.',
      ],
      foodToTry: [
        'A fresh croissant from a neighbourhood boulangerie.',
        'Steak-frites at a classic bistro.',
        'Falafel in Le Marais.',
        'Macarons and a café crème in the afternoon.',
      ],
      gettingAround: [
        'The Metro is the fastest way across the city.',
        'Walking is lovely — central Paris is compact.',
        'Use Vélib’ bikes for short, flat hops.',
        'Avoid taxis in traffic; the Metro is usually quicker.',
      ],
    ),
  };
}
