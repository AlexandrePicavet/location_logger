import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart';
import 'package:location_logger/features/location/application/port/model/error/location_gathering_error.dart';

abstract class LocationGatheringPort {
  TaskEither<LocationGatheringError, Location> call();
}
