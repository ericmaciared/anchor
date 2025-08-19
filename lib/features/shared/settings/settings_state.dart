import 'package:flutter/material.dart';

class SettingsState {
  final String profileName;
  final TimeOfDay wakeUpTime;
  final TimeOfDay bedTime;
  final String displayDensity;
  final bool dailyQuotesEnabled;
  final bool visualEffectsEnabled;
  final bool liquidGlassEnabled;
  final bool statusMessageEnabled;

  SettingsState({
    required this.profileName,
    required this.wakeUpTime,
    required this.bedTime,
    required this.displayDensity,
    required this.dailyQuotesEnabled,
    required this.visualEffectsEnabled,
    required this.liquidGlassEnabled,
    required this.statusMessageEnabled,
  });

  SettingsState copyWith({
    String? profileName,
    TimeOfDay? wakeUpTime,
    TimeOfDay? bedTime,
    String? displayDensity,
    bool? dailyQuotesEnabled,
    bool? visualEffectsEnabled,
    bool? liquidGlassEnabled,
    bool? statusMessageEnabled,
  }) {
    return SettingsState(
      profileName: profileName ?? this.profileName,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      bedTime: bedTime ?? this.bedTime,
      displayDensity: displayDensity ?? this.displayDensity,
      dailyQuotesEnabled: dailyQuotesEnabled ?? this.dailyQuotesEnabled,
      visualEffectsEnabled: visualEffectsEnabled ?? this.visualEffectsEnabled,
      liquidGlassEnabled: liquidGlassEnabled ?? this.liquidGlassEnabled,
      statusMessageEnabled: statusMessageEnabled ?? this.statusMessageEnabled,
    );
  }
}
