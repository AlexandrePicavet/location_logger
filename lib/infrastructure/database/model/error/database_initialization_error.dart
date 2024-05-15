class DatabaseInitializationError extends Error {
  final Object cause;

  DatabaseInitializationError(this.cause);
}
