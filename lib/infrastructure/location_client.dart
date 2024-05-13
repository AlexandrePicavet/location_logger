import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart';
import 'package:location_logger/infrastructure/model/error/location_initialization_error.dart';
import 'package:location_logger/infrastructure/model/exception/get_location_exception.dart';

class LocationClient {
  final Location _location = Location();

  TaskEither<LocationInitializationError, LocationClient> initialize() {
    return TaskEither.tryCatch(
      () async {
        await _enableService();
        await _requestPermission();

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
