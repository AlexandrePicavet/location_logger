class LocationInitializationError extends Error {
  final Object cause;

  LocationInitializationError(this.cause);
}
