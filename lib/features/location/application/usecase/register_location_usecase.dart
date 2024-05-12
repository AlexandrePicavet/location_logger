import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/error/location_update_error.dart';

abstract class RegisterCurrentLocationUsecase {
  TaskEither<LocationUpdateError, void> register();
}
