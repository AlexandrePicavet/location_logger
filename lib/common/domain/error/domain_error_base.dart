abstract class DomainErrorBase extends Error {
  abstract final List<Type> allowedErrors;

  final Error cause;

  DomainErrorBase(this.cause) {
    _checkCauseType(cause.runtimeType);
  }

  Never? _checkCauseType(Type causeType) {
    if (!allowedErrors.contains(causeType)) {
      throw ArgumentError(
        "The source is of type $causeType. But should be one of: $allowedErrors",
        "source",
      );
    }
  }
}
