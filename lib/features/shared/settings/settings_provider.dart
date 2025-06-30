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
    final bool visualEffectsEnabled =
        _prefs.getBool('visualEffectsEnabled') ?? true;

    return SettingsState(
      profileName: profileName,
      wakeUpTime: wakeUpTime,
      bedTime: bedTime,
      displayDensity: displayDensity,
      dailyQuotesEnabled: dailyQuotesEnabled,
      visualEffectsEnabled: visualEffectsEnabled,
    );
  }

  Future<void> updateProfileName(String newName) async {
    state = AsyncValue.data(state.value!.copyWith(profileName: newName));
    await _prefs.setString('profileName', newName);
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

  Future<void> updateVisualEffectsEnabled(bool enabled) async {
    state =
        AsyncValue.data(state.value!.copyWith(visualEffectsEnabled: enabled));
    await _prefs.setBool('visualEffectsEnabled', enabled);
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
    SettingsNotifier.new);
