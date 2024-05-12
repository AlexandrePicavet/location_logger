class LocationPersistenceException implements Exception {
  final Object cause;

  LocationPersistenceException(this.cause);
}
