abstract class DomainException implements Exception {
  abstract final List<Type> allowedExceptions;

  final Exception cause;

  DomainException(this.cause) {
    _checkCauseType(cause.runtimeType);
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
