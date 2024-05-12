import 'package:location_logger/common/domain/exception/domain_error_base.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_retrieval_exception.dart';

class ListLocationException extends DomainException {
  @override
  final List<Type> allowedExceptions = [LocationRetrievalException];

  ListLocationException(super.cause);
}
