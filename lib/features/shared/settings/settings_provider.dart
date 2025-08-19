import 'package:anchor/features/shared/settings/settings_constants.dart';
import 'package:anchor/features/shared/settings/settings_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

/// Convenience provider for quick access to current settings
final currentSettingsProvider = Provider<SettingsState?>((ref) {
  return ref.watch(settingsProvider).valueOrNull;
});

/// Provider to check if settings are loading
final settingsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isLoading;
});

/// Provider to check if settings failed to load
final settingsErrorProvider = Provider<Object?>((ref) {
  final asyncValue = ref.watch(settingsProvider);
  return asyncValue.hasError ? asyncValue.error : null;
});

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  SharedPreferences? _prefs;
  bool _prefsInitialized = false;

  @override
  Future<SettingsState> build() async {
    try {
      await _initializePreferences();
      return await _loadSettings();
    } catch (e, stackTrace) {
      // Log error in debug mode
      if (kDebugMode) {
        debugPrint('Failed to initialize settings: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      // Return default settings if initialization fails
      return _getDefaultSettings();
    }
  }

  /// Initialize SharedPreferences with retry logic
  Future<void> _initializePreferences() async {
    if (_prefsInitialized && _prefs != null) return;

    const maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries && !_prefsInitialized) {
      try {
        _prefs = await SharedPreferences.getInstance();
        _prefsInitialized = true;
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          throw Exception('Failed to initialize SharedPreferences after $maxRetries attempts: $e');
        }

        // Wait before retrying
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
        if (kDebugMode) {
          debugPrint('Retrying SharedPreferences initialization (attempt $retryCount)');
        }
      }
    }
  }

  /// Load settings from SharedPreferences with fallback to defaults
  Future<SettingsState> _loadSettings() async {
    if (!_prefsInitialized || _prefs == null) {
      return _getDefaultSettings();
    }

    try {
      final profileName = _prefs!.getString(SettingsKeys.profileName) ?? SettingsDefaults.profileName;

      final wakeUpTime = _parseTimeOfDay(
        _prefs!.getString(SettingsKeys.wakeUpTime),
        SettingsDefaults.wakeUpTime,
      );

      final bedTime = _parseTimeOfDay(
        _prefs!.getString(SettingsKeys.bedTime),
        SettingsDefaults.bedTime,
      );

      final displayDensity = _prefs!.getString(SettingsKeys.displayDensity) ?? SettingsDefaults.displayDensity;

      final dailyQuotesEnabled =
          _prefs!.getBool(SettingsKeys.dailyQuotesEnabled) ?? SettingsDefaults.dailyQuotesEnabled;

      final visualEffectsEnabled =
          _prefs!.getBool(SettingsKeys.visualEffectsEnabled) ?? SettingsDefaults.visualEffectsEnabled;

      final liquidGlassEnabled =
          _prefs!.getBool(SettingsKeys.liquidGlassEnabled) ?? SettingsDefaults.liquidGlassEnabled;

      final statusMessageEnabled =
          _prefs!.getBool(SettingsKeys.statusMessageEnabled) ?? SettingsDefaults.statusMessageEnabled;

      return SettingsState(
        profileName: profileName,
        wakeUpTime: wakeUpTime,
        bedTime: bedTime,
        displayDensity: displayDensity,
        dailyQuotesEnabled: dailyQuotesEnabled,
        visualEffectsEnabled: visualEffectsEnabled,
        liquidGlassEnabled: liquidGlassEnabled,
        statusMessageEnabled: statusMessageEnabled,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading settings, using defaults: $e');
      }
      return _getDefaultSettings();
    }
  }

  /// Get default settings state
  SettingsState _getDefaultSettings() {
    return SettingsState(
      profileName: SettingsDefaults.profileName,
      wakeUpTime: SettingsDefaults.wakeUpTime,
      bedTime: SettingsDefaults.bedTime,
      displayDensity: SettingsDefaults.displayDensity,
      dailyQuotesEnabled: SettingsDefaults.dailyQuotesEnabled,
      visualEffectsEnabled: SettingsDefaults.visualEffectsEnabled,
      liquidGlassEnabled: SettingsDefaults.liquidGlassEnabled,
      statusMessageEnabled: SettingsDefaults.statusMessageEnabled,
    );
  }

  /// Parse TimeOfDay from string with fallback
  TimeOfDay _parseTimeOfDay(String? timeString, TimeOfDay fallback) {
    if (timeString == null || timeString.isEmpty) return fallback;

    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return fallback;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return fallback;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to parse time "$timeString": $e');
      }
      return fallback;
    }
  }

  /// Format TimeOfDay to string
  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  /// Safely set string value in SharedPreferences
  Future<bool> _safeSetString(String key, String value) async {
    try {
      await _initializePreferences();
      if (_prefs == null) return false;

      return await _prefs!.setString(key, value);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save string setting $key: $e');
      }
      return false;
    }
  }

  /// Safely set boolean value in SharedPreferences
  Future<bool> _safeSetBool(String key, bool value) async {
    try {
      await _initializePreferences();
      if (_prefs == null) return false;

      return await _prefs!.setBool(key, value);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save boolean setting $key: $e');
      }
      return false;
    }
  }

  /// Update the state and save to preferences
  Future<void> _updateStateAndSave(
    SettingsState newState,
    Future<bool> Function() saveOperation,
    String settingName,
  ) async {
    // Update state optimistically
    state = AsyncValue.data(newState);

    try {
      final saved = await saveOperation();
      if (!saved) {
        if (kDebugMode) {
          debugPrint('Warning: Failed to persist $settingName setting');
        }
        // Could show a snackbar or toast to user here
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error saving $settingName: $e');
      }
      // State is already updated optimistically, so we keep the change
      // but could implement retry logic or revert state here if needed
    }
  }

  // Public methods for updating settings

  Future<void> updateProfileName(String newName) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    // Validate input
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) {
      if (kDebugMode) {
        debugPrint('Profile name cannot be empty');
      }
      return;
    }

    if (trimmedName.length > 50) {
      if (kDebugMode) {
        debugPrint('Profile name too long (max 50 characters)');
      }
      return;
    }

    final newState = currentState.copyWith(profileName: trimmedName);
    await _updateStateAndSave(
      newState,
      () => _safeSetString(SettingsKeys.profileName, trimmedName),
      'profile name',
    );
  }

  Future<void> updateWakeUpTime(TimeOfDay newTime) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final newState = currentState.copyWith(wakeUpTime: newTime);
    await _updateStateAndSave(
      newState,
      () => _safeSetString(SettingsKeys.wakeUpTime, _formatTimeOfDay(newTime)),
      'wake up time',
    );
  }

  Future<void> updateBedTime(TimeOfDay newTime) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final newState = currentState.copyWith(bedTime: newTime);
    await _updateStateAndSave(
      newState,
      () => _safeSetString(SettingsKeys.bedTime, _formatTimeOfDay(newTime)),
      'bed time',
    );
  }

  Future<void> updateDisplayDensity(String newDensity) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    // Validate density value
    const validDensities = ['Compact', 'Spacious'];
    if (!validDensities.contains(newDensity)) {
      if (kDebugMode) {
        debugPrint('Invalid display density: $newDensity');
      }
      return;
    }

    final newState = currentState.copyWith(displayDensity: newDensity);
    await _updateStateAndSave(
      newState,
      () => _safeSetString(SettingsKeys.displayDensity, newDensity),
      'display density',
    );
  }

  Future<void> updateDailyQuotesEnabled(bool enabled) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final newState = currentState.copyWith(dailyQuotesEnabled: enabled);
    await _updateStateAndSave(
      newState,
      () => _safeSetBool(SettingsKeys.dailyQuotesEnabled, enabled),
      'daily quotes enabled',
    );
  }

  Future<void> updateVisualEffectsEnabled(bool enabled) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final newState = currentState.copyWith(visualEffectsEnabled: enabled);
    await _updateStateAndSave(
      newState,
      () => _safeSetBool(SettingsKeys.visualEffectsEnabled, enabled),
      'visual effects enabled',
    );
  }

  Future<void> updateLiquidGlassEnabled(bool enabled) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final newState = currentState.copyWith(liquidGlassEnabled: enabled);
    await _updateStateAndSave(
      newState,
      () => _safeSetBool(SettingsKeys.visualEffectsEnabled, enabled),
      'visual effects enabled',
    );
  }

  Future<void> updateStatusMessageEnabled(bool enabled) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final newState = currentState.copyWith(statusMessageEnabled: enabled);
    await _updateStateAndSave(
      newState,
      () => _safeSetBool(SettingsKeys.statusMessageEnabled, enabled),
      'status message enabled',
    );
  }

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    try {
      await _initializePreferences();
      if (_prefs != null) {
        await _prefs!.clear();
      }

      final defaultState = _getDefaultSettings();
      state = AsyncValue.data(defaultState);

      if (kDebugMode) {
        debugPrint('Settings reset to defaults');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to reset settings: $e');
      }
    }
  }

  /// Check if settings are available (SharedPreferences initialized)
  bool get isAvailable => _prefsInitialized && _prefs != null;

  /// Get current settings synchronously (returns null if not loaded)
  SettingsState? get currentSettings => state.valueOrNull;
}
