import 'package:flutter/material.dart';

class SettingsState {
  final String profileName;
  final TimeOfDay wakeUpTime;
  final TimeOfDay bedTime;
  final String displayDensity;
  final bool dailyQuotesEnabled;
  final int profileColor;

  SettingsState({
    required this.profileName,
    required this.wakeUpTime,
    required this.bedTime,
    required this.displayDensity,
    required this.dailyQuotesEnabled,
    required this.profileColor,
  });

  SettingsState copyWith({
    String? profileName,
    TimeOfDay? wakeUpTime,
    TimeOfDay? bedTime,
    String? displayDensity,
    bool? dailyQuotesEnabled,
    int? profileColor,
  }) {
    return SettingsState(
      profileName: profileName ?? this.profileName,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      bedTime: bedTime ?? this.bedTime,
      displayDensity: displayDensity ?? this.displayDensity,
      dailyQuotesEnabled: dailyQuotesEnabled ?? this.dailyQuotesEnabled,
      profileColor: profileColor ?? this.profileColor,
    );
  }
}
