import 'package:location_logger/common/domain/exception/domain_error_base.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_persistence_exception.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_gathering_exception.dart';

class LocationUpdateException extends DomainException {
  @override
  final List<Type> allowedExceptions = [
    LocationPersistenceException,
    LocationGatheringException
  ];

  LocationUpdateException(super.cause);
}
