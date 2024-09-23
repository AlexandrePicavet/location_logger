import 'package:fpdart/fpdart.dart';
import 'package:location_logger/common/model/exception/location_logger_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';

class LocationMappingException extends LocationLoggerException {
  LocationMappingException(super.cause);
}

extension MapToLocation on Map<String, Object?> {
  // TODO enhance by ignoring errors on optional fields
  Either<LocationMappingException, Location> toLocation() => Either.tryCatch(
        () => Location(
          dateTime:
              DateTime.fromMillisecondsSinceEpoch(this["timestamp"] as int),
          latitude: double.parse(this["latitude"] as String),
          longitude: double.parse(this["longitude"] as String),
          altitude: Option.fromNullable(this["altitude"] as String?)
              .map(double.parse)
              .toNullable(),
          speed: Option.fromNullable(this["speed"] as String?)
              .map(double.parse)
              .toNullable(),
        ),
        (error, stackTrace) => LocationMappingException(error),
      );
}
