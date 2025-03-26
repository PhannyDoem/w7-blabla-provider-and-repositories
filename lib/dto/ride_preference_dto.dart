

import '../model/location/locations.dart';
import '../model/ride/ride_pref.dart';

class RidePreferenceDto {
  final Location departure;
  final DateTime departureDate;
  final Location arrival;
  final int requestedSeats;

  RidePreferenceDto({
    required this.departure,
    required this.departureDate,
    required this.arrival,
    required this.requestedSeats,
  });

  factory RidePreferenceDto.fromJson(Map<String, dynamic> json) {
    return RidePreferenceDto(
      departure: Location.fromJson(json['departure'] as Map<String, dynamic>),
      departureDate: DateTime.parse(json['departureDate'] as String),
      arrival: Location.fromJson(json['arrival'] as Map<String, dynamic>),
      requestedSeats: json['requestedSeats'] as int,
    );
  }

  RidePreference toRidePreference() {
    return RidePreference(
      departure: departure,
      departureDate: departureDate,
      arrival: arrival,
      requestedSeats: requestedSeats,
    );
  }

  Map<String, dynamic> toJson(RidePreference pref) {
    return {
      'departure': departure.toJson(),
      'departureDate': departureDate.toIso8601String(),
      'arrival': arrival.toJson(),
      'requestedSeats': requestedSeats,
    };
  }

  static fromRidePreference(RidePreference pref) {
    return RidePreferenceDto(
      departure: pref.departure,
      departureDate: pref.departureDate,
      arrival: pref.arrival,
      requestedSeats: pref.requestedSeats,
    );
  }
}
