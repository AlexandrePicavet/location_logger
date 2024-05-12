import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/exception/location_update_exception.dart';

abstract class RegisterCurrentLocationUsecase {
  TaskEither<LocationUpdateException, void> register();
}
