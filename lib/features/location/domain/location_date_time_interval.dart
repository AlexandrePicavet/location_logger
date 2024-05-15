class LocationDateTimeInterval {
  final DateTime? start;
  final DateTime? end;

  LocationDateTimeInterval.between({required this.start, required this.end}) {
    _checkIntegrity();
  }

  LocationDateTimeInterval.before({required this.end}) : start = null {
    _checkIntegrity();
  }

  LocationDateTimeInterval.after({required this.start}) : end = null {
    _checkIntegrity();
  }

  Never? _checkIntegrity() {
    if (start == null && end == null) {
      throw ArgumentError("Either start or end must not be null");
    } else if (start != null && end != null && start!.second > end!.second) {
      throw ArgumentError(
        "End ($end) must be greater or equal to start ($start)",
      );
    }
  }

  // TODO Add toString: (from xxx to xxx)
}
