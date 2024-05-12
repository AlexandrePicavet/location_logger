import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart';
import 'package:location_logger/features/location/application/port/model/error/location_persistence_error.dart';

abstract class LocationPersistencePort {
  TaskEither<LocationPersistenceError, void> persist(Location location);
}
