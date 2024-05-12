class DatabaseInsertException implements Exception {
  final Object cause;

  DatabaseInsertException(this.cause);
}
