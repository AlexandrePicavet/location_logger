import 'package:fpdart/fpdart.dart';
import 'package:fpdart/src/task_either.dart';
import 'package:location/location.dart' as API;
import 'package:location_logger/features/location/adapter/model/mapper/location_data_to_location.dart';
import 'package:location_logger/features/location/application/port/location_gathering_port.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_gathering_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';

class LocationGatheringAdapter extends LocationGatheringPort {
  final API.Location locationClient;

  LocationGatheringAdapter(this.locationClient);

  @override
  TaskEither<LocationGatheringException, Location> call() {
    return configureService(locationClient)
        .andThen(() => getLocation(locationClient))
        .chainEither(
          (locationData) => locationData.toLocation().toEither(
                () => LocationGatheringException(
                  "Missing data from the location data",
                ),
              ),
        );
  }

  static TaskEither<LocationGatheringException, API.LocationData> getLocation(
    API.Location locationClient,
  ) {
    return TaskEither.tryCatch(
      () => locationClient.getLocation(),
      (error, stacktrace) => LocationGatheringException(error),
    );
  }

  static TaskEither<LocationGatheringException, void> configureService(
    API.Location locationClient,
  ) {
    return TaskEither.tryCatch(
      () async {
        await _enableService(locationClient);
        await _requestPermission(locationClient);
      },
      (error, stackTrace) => LocationGatheringException(error),
    );
  }

  static Future<void> _enableService(
    API.Location locationClient,
  ) async {
    if (await locationClient.serviceEnabled()) {
      await locationClient.requestService();
    }
  }

  static Future<void> _requestPermission(
    API.Location locationClient,
  ) async {
    while (!(await _hasPermission(locationClient))) {
      await locationClient.requestPermission();
    }
  }

  static Future<bool> _hasPermission(
    API.Location locationClient,
  ) async {
    final permission = await locationClient.hasPermission();
    return permission == API.PermissionStatus.granted ||
        permission == API.PermissionStatus.grantedLimited;
  }
}
