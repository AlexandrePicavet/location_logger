import 'package:location_logger/common/domain/error/domain_error_base.dart';
import 'package:location_logger/features/location/application/port/model/error/location_persistence_error.dart';
import 'package:location_logger/features/location/application/port/model/error/location_gathering_error.dart';

class LocationUpdateError extends DomainErrorBase {
  @override
  final List<Type> allowedErrors = [
    LocationPersistenceError,
    LocationGatheringError
  ];

  LocationUpdateError(super.cause);
}
