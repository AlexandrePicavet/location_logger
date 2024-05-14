import 'package:location_logger/common/model/exception/location_logger_exception.dart';

abstract class DomainException extends LocationLoggerException {
  abstract final List<Type> allowedExceptions;

  DomainException(super.cause) {
    _checkCauseType(getCause().runtimeType);
  }

  Never? _checkCauseType(Type causeType) {
    if (!allowedExceptions.contains(causeType)) {
      throw ArgumentError(
        "The source is of type $causeType. But should be one of: $allowedExceptions",
        "source",
      );
    }
  }
}
