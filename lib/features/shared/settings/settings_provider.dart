import 'dart:math'; // Import for Random class

import 'package:anchor/features/shared/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  Future<SettingsState> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _loadSettings();
  }

  Future<SettingsState> _loadSettings() async {
    final String profileName = _prefs.getString('profileName') ?? 'User Name';

    final String? wakeUpTimeString = _prefs.getString('wakeUpTime');
    final TimeOfDay wakeUpTime = wakeUpTimeString != null
        ? TimeOfDay(
            hour: int.parse(wakeUpTimeString.split(':')[0]),
            minute: int.parse(wakeUpTimeString.split(':')[1]),
          )
        : TimeOfDay.now();

    final String? bedTimeString = _prefs.getString('bedTime');
    final TimeOfDay bedTime = bedTimeString != null
        ? TimeOfDay(
            hour: int.parse(bedTimeString.split(':')[0]),
            minute: int.parse(bedTimeString.split(':')[1]),
          )
        : TimeOfDay(hour: 22, minute: 0);

    final String displayDensity =
        _prefs.getString('displayDensity') ?? 'Normal';
    final bool dailyQuotesEnabled =
        _prefs.getBool('dailyQuotesEnabled') ?? true;

    // Load profile color, or generate and save if not found
    int? storedColorValue = _prefs.getInt('profileColor');
    int profileColor;
    if (storedColorValue == null) {
      final Random random = Random();
      profileColor = Color.fromARGB(
        255, // Opacity
        random.nextInt(200) + 55, // Red (avoid too dark or too light)
        random.nextInt(200) + 55, // Green
        random.nextInt(200) + 55, // Blue
      ).toARGB32(); // Get the integer representation of the color
      await _prefs.setInt('profileColor', profileColor);
    } else {
      profileColor = storedColorValue;
    }

    return SettingsState(
      profileName: profileName,
      wakeUpTime: wakeUpTime,
      bedTime: bedTime,
      displayDensity: displayDensity,
      dailyQuotesEnabled: dailyQuotesEnabled,
      profileColor: profileColor, // Pass the loaded/generated color
    );
  }

  Future<void> updateProfileName(String newName) async {
    state = AsyncValue.data(state.value!.copyWith(profileName: newName));
    await _prefs.setString('profileName', newName);
  }

  Future<void> updateProfileColor(int newColorValue) async {
    state = AsyncValue.data(state.value!.copyWith(profileColor: newColorValue));
    await _prefs.setInt('profileColor', newColorValue);
  }

  Future<void> updateWakeUpTime(TimeOfDay newTime) async {
    state = AsyncValue.data(state.value!.copyWith(wakeUpTime: newTime));
    await _prefs.setString('wakeUpTime', '${newTime.hour}:${newTime.minute}');
  }

  Future<void> updateBedTime(TimeOfDay newTime) async {
    state = AsyncValue.data(state.value!.copyWith(bedTime: newTime));
    await _prefs.setString('bedTime', '${newTime.hour}:${newTime.minute}');
  }

  Future<void> updateDisplayDensity(String newDensity) async {
    state = AsyncValue.data(state.value!.copyWith(displayDensity: newDensity));
    await _prefs.setString('displayDensity', newDensity);
  }

  Future<void> updateDailyQuotesEnabled(bool enabled) async {
    state = AsyncValue.data(state.value!.copyWith(dailyQuotesEnabled: enabled));
    await _prefs.setBool('dailyQuotesEnabled', enabled);
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
    SettingsNotifier.new);
