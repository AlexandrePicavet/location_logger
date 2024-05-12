class Location {
  /// Date & time of the location record
  final DateTime dateTime;

  /// Latitude in degrees
  final double latitude;

  /// Longitude, in degrees
  final double longitude;

  /// In meters above the WGS 84 reference ellipsoid. Derived from GPS information.
  final double altitude;

  /// In meters/second
  ///
  /// null if unavailable.
  final double? speed;

  Location({
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    this.speed,
  });
}
