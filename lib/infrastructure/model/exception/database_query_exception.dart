class DatabaseQueryException implements Exception {
  final Object cause;

  DatabaseQueryException(this.cause);
}
