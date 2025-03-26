import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/dto/ride_preference_dto.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = 'ride_preferences';

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    try {
      // Get shared preferences instance
      final prefs = await SharedPreferences.getInstance();

      // Get the preferences
      final prefsList = prefs.getStringList(_preferencesKey) ?? [];

      // Convert the preferences to RidePreference
      return prefsList
          .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
          .map((dto) => dto.toRidePreference())
          .toList();
    } catch (e) {
      throw Exception('Failed to load past preferences: $e');
    }
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    try {
      // Get the past preferences
      final prefs = await getPastPreferences();

      // add the prefererence
      if (!prefs.contains(preference)) {
        prefs.add(preference);
      }

      // Set the new list as string list
      final sharedPrefs = await SharedPreferences.getInstance();

      // Convert the preferences to string
      final prefsString = prefs
          .map((pref) =>
              jsonEncode(RidePreferenceDto.fromRidePreference(pref).toJson()))
          .toList();
      final success =
          await sharedPrefs.setStringList(_preferencesKey, prefsString);
      if (!success) {
        throw Exception('Failed to save preferences to SharedPreferences');
      }
    } catch (e) {
      throw Exception('Failed to add past preference: $e');
    }
  }
}
