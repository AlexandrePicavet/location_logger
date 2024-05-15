import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart' show LocationData;
import 'package:location_logger/features/location/adapter/model/mapper/location_data_to_location.dart';
import 'package:location_logger/features/location/application/port/location_gathering_port.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_gathering_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';
import 'package:location_logger/infrastructure/android/location_client.dart';

class LocationGatheringAdapter implements LocationGatheringPort {
  final LocationClient _locationClient;

  LocationGatheringAdapter(this._locationClient);

  @override
  TaskEither<LocationGatheringException, Location> retrieve() {
    return _locationClient
        .getLocation()
        .mapLeft(LocationGatheringException.new)
        .chainEither(_toLocation);
  }

  @override
  StreamSubscription<Location> listenUpdates({
    required Future<void> Function(Location) onLocationUpdate,
  }) {
    return _locationClient
        .onLocationChanged()
        .map(_toLocation)
        .where((location) => location.isRight())
        .map((location) => location.getOrElse((error) => throw error))
        .listen(onLocationUpdate);
  }

  Either<LocationGatheringException, Location> _toLocation(
    LocationData locationData,
  ) {
    return locationData.toLocation().toEither(
          () => LocationGatheringException(
            "Missing data from the location data",
          ),
        );
  }
}
