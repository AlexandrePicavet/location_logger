import 'package:location_logger/common/domain/error/domain_error_base.dart';
import 'package:location_logger/features/location/application/port/model/error/location_retrieval_error.dart';

class ListLocationError extends DomainErrorBase {
  @override
  final List<Type> allowedErrors = [LocationRetrievalError];

  ListLocationError(super.cause);
}
