abstract class LocationLoggerException implements Exception {
  final Object _cause;

  LocationLoggerException(this._cause);

  Object getCause() {
    return _cause;
  }

  Object getRootCause() {
    return switch (_cause) {
      LocationLoggerException() => _cause.getRootCause(),
      _ => _cause,
    };
  }

  List<Object> getCauses() {
    final causes = <Object>[];
    _addCauses(causes);
    return causes;
  }

  void _addCauses(List<Object> causes) {
    causes.add(this);

    return switch (_cause) {
      LocationLoggerException() => _cause._addCauses(causes),
      _ => causes.add(_cause)
    };
  }
}
