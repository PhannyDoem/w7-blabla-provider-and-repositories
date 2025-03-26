import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';

import '../../model/ride/ride_pref.dart';

class RidePrefProivder extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> _pastPreferences;

  // Constructor
  final RidePreferencesRepository ridePreferencesRepository;

  Future<void> _fetchPastPreferences() async {
    // Loading
    _pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      // Fetch the past preferences
      List<RidePreference> pastPrefs = (await ridePreferencesRepository.getPastPreferences());
      // Success
      _pastPreferences = AsyncValue.success(pastPrefs);
    } catch (e) {
      // Error
      _pastPreferences = AsyncValue.error(e);
    }

    notifyListeners();
  }

  RidePrefProivder({required this.ridePreferencesRepository}) {
    _fetchPastPreferences();
  }

  // get current preference

  RidePreference? get currentPreference => _currentPreference;

  // Set the current preference

  void setCurrentPreference(RidePreference ridePreference) {
    if (ridePreference == _currentPreference) {
      return;
    } else {
      _currentPreference = ridePreference;
      _addPreference(ridePreference);
      notifyListeners();
    }
  }

  void _addPreference(RidePreference ridePreference) async {
    // Check if the preference already exists in the list
    if (_pastPreferences.data != null &&
        _pastPreferences.data!.contains(ridePreference)) {
      return;
    }

    // Call the repository to add the preference
    await ridePreferencesRepository.addPreference(ridePreference);

    // Fetch the updated list of past preferences after adding
    _fetchPastPreferences();
  }

  // Get the list of past preference newest to oldest
  List<RidePreference> get pastPreferences {
    if (_pastPreferences.data != null) {
      return _pastPreferences.data!.reversed.toList();
    } else {
      return [];
    }
  }

  // Public getter for the pastPreferences state
  AsyncValue<List<RidePreference>> get pastPreferencesState => _pastPreferences;
}
