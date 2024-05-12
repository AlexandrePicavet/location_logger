import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_persistence_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';

abstract class LocationPersistencePort {
  TaskEither<LocationPersistenceException, void> persist(Location location);
}
