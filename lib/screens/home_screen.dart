import 'package:flutter/material.dart';

import '../models/travel_guide.dart';
import '../services/guide_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final GuideService _service = GuideService();

  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generateGuide() async {
    final destination = _controller.text.trim();

    // Step 4: validation for empty input.
    if (destination.isEmpty) {
      setState(() => _errorText = 'Please enter a destination');
      return;
    }

    // Capture the navigator BEFORE the async gap so we never use
    // BuildContext after an await (safe across strict analyzers).
    final navigator = Navigator.of(context);

    // Step 5: loading state.
    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    final guide = await _service.generateGuide(destination);

    if (!mounted) return;
    setState(() => _isLoading = false);

    await navigator.push(
      MaterialPageRoute(builder: (_) => ResultScreen(guide: guide)),
    );
  }

  void _useExample(String city) {
    _controller.text = city;
    setState(() => _errorText = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.travel_explore,
                    size: 64, color: Color(0xFF2563EB)),
                const SizedBox(height: 16),
                const Text(
                  'TourBuddy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explore smarter. Avoid tourist traps.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (_) => _generateGuide(),
                  decoration: InputDecoration(
                    hintText: 'Enter destination',
                    errorText: _errorText,
                    prefixIcon: const Icon(Icons.place_outlined),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: ['Bali', 'Dubai', 'Paris']
                      .map((city) => ActionChip(
                            label: Text(city),
                            onPressed: () => _useExample(city),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _generateGuide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Generate Guide',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
