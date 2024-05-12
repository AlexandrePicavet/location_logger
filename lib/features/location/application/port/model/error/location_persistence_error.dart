class LocationPersistenceError extends Error {
  final Error cause;

  LocationPersistenceError(this.cause);
}
