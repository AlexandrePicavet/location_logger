class LocationGatheringError extends Error {
  final Error cause;

  LocationGatheringError(this.cause);
}
