import 'package:location_logger/common/model/exception/location_logger_exception.dart';

class ExiftoolExporterInitializationException extends LocationLoggerException {
  ExiftoolExporterInitializationException(super.cause);
}

enum ExiftoolExporterInitializationExceptionCause {
  permissionPermanentlyDenied,
  permissionNotGranted,
}
