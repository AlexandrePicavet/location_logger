import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart';
import 'package:location_logger/infrastructure/model/error/location_initialization_error.dart';
import 'package:location_logger/infrastructure/model/exception/background_location_exception.dart';
import 'package:location_logger/infrastructure/model/exception/get_location_exception.dart';

class LocationClient {
  static const _distanceFilterInMeter = 10.0;
  final Location _location = Location();

  TaskEither<LocationInitializationError, LocationClient> initialize({
    LocationAccuracy accuracy = LocationAccuracy.powerSave,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _enableService();
        await _requestPermission();
        await _location.changeSettings(
          accuracy: accuracy,
          distanceFilter: _distanceFilterInMeter,
        );

        try {
          final backgroundModeEnabled = await _location.enableBackgroundMode();
          if (!backgroundModeEnabled) {
            throw BackgroundLocationException(
              "Failed to enable background mode",
            );
          }
        } catch (e) {
          // TODO Permissions not available in the background send a notification ?
          print(e);
        }

        return this;
      },
      (error, stackTrace) => LocationInitializationError(error),
    );
  }

  TaskEither<GetLocationException, LocationData> getLocation() {
    return TaskEither.tryCatch(
      () => _location.getLocation(),
      (error, stacktrace) => GetLocationException(error),
    );
  }

  Stream<LocationData> onLocationChanged() {
    return _location.onLocationChanged;
  }

  Future<void> _enableService() async {
    if (await _location.serviceEnabled()) {
      await _location.requestService();
    }
  }

  Future<void> _requestPermission() async {
    while (!(await _hasPermission())) {
      await _location.requestPermission();
    }
  }

  Future<bool> _hasPermission() async {
    final permission = await _location.hasPermission();
    return permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited;
  }
}
