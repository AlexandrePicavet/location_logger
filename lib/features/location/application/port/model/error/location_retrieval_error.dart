class LocationRetrievalError extends Error {
  final Error cause;

  LocationRetrievalError(this.cause);
}
