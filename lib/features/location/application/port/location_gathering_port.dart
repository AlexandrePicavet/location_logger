import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_gathering_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';

abstract class LocationGatheringPort {
  TaskEither<LocationGatheringException, Location> call();
}
