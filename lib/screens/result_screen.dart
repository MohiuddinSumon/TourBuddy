import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/travel_guide.dart';

class ResultScreen extends StatelessWidget {
  final TravelGuide guide;

  const ResultScreen({super.key, required this.guide});

  void _copyGuide(BuildContext context) {
    Clipboard.setData(ClipboardData(text: guide.toShareText()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Guide copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        title: Text(
          guide.destination,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Copy Guide',
            icon: const Icon(Icons.copy_rounded),
            onPressed: () => _copyGuide(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SectionCard(
            icon: Icons.attractions,
            color: const Color(0xFF2563EB),
            title: 'Things to Do',
            items: guide.topThingsToDo,
          ),
          _SectionCard(
            icon: Icons.warning_amber_rounded,
            color: const Color(0xFFDC2626),
            title: 'Scams to Avoid',
            items: guide.scamsToAvoid,
          ),
          _SectionCard(
            icon: Icons.lightbulb_outline,
            color: const Color(0xFFD97706),
            title: 'Local Tips',
            items: guide.localTips,
          ),
          _SectionCard(
            icon: Icons.restaurant,
            color: const Color(0xFF059669),
            title: 'Food to Try',
            items: guide.foodToTry,
          ),
          _SectionCard(
            icon: Icons.directions_transit,
            color: const Color(0xFF7C3AED),
            title: 'Getting Around',
            items: guide.gettingAround,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<GuideItem> items;

  const _SectionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 10),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.3,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          if (item.description.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
