import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/location.dart';

extension MapToLocation on Map<String, Object?> {
  Location toLocation() => Location(
        dateTime: DateTime.fromMillisecondsSinceEpoch(this["timestamp"] as int),
        latitude: double.parse(this["latitude"] as String),
        longitude: double.parse(this["longitude"] as String),
        altitude: Option.fromNullable(this["altitude"] as String?)
            .map(double.parse)
            .toNullable(),
        speed: Option.fromNullable(this["speed"] as String?)
            .map(double.parse)
            .toNullable(),
      );
}
