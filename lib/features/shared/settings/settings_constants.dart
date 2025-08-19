import 'package:flutter/material.dart';

class SettingsKeys {
  static const String profileName = 'profileName';
  static const String wakeUpTime = 'wakeUpTime';
  static const String bedTime = 'bedTime';
  static const String displayDensity = 'displayDensity';
  static const String dailyQuotesEnabled = 'dailyQuotesEnabled';
  static const String visualEffectsEnabled = 'visualEffectsEnabled';
  static const String liquidGlassEnabled = 'liquidGlassEnabled';
  static const String statusMessageEnabled = 'statusMessageEnabled';
}

// Default values
class SettingsDefaults {
  static const String profileName = 'User Name';
  static const TimeOfDay wakeUpTime = TimeOfDay(hour: 8, minute: 0);
  static const TimeOfDay bedTime = TimeOfDay(hour: 22, minute: 0);
  static const String displayDensity = 'Compact';
  static const bool dailyQuotesEnabled = true;
  static const bool visualEffectsEnabled = true;
  static const bool liquidGlassEnabled = true;
  static const bool statusMessageEnabled = true;
}
