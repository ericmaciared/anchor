import 'package:shared_preferences/shared_preferences.dart';

class NotificationIdGenerator {
  static const String _counterKey = 'notification_id_counter';
  static int? _cachedCounter;
  static bool _isInitialized = false;

  /// Initialize the counter from SharedPreferences
  static Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedCounter = prefs.getInt(_counterKey) ?? 1000; // Start from 1000 to avoid conflicts
      _isInitialized = true;
    } catch (e) {
      // Fallback to timestamp-based ID if SharedPreferences fails
      _cachedCounter = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      _isInitialized = true;
    }
  }

  /// Generate the next unique notification ID
  static Future<int> next() async {
    await _initialize();

    _cachedCounter = _cachedCounter! + 1;

    // Persist the new counter value
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_counterKey, _cachedCounter!);
    } catch (e) {
      // If we can't persist, use timestamp to avoid conflicts
      _cachedCounter = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }

    return _cachedCounter!;
  }

  /// Reset the counter (useful for testing)
  static Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_counterKey);
      _cachedCounter = null;
      _isInitialized = false;
    } catch (e) {
      _cachedCounter = null;
      _isInitialized = false;
    }
  }

  /// Get current counter value without incrementing
  static Future<int> current() async {
    await _initialize();
    return _cachedCounter!;
  }
}
