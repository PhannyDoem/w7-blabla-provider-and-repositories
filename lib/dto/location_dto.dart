class LocationDto {
  final String name;
  final String country;

  LocationDto({
    required this.name,
    required this.country,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      name: json['name'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
    };
  }
}
