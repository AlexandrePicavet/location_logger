import 'package:fpdart/fpdart.dart';
import 'package:location_logger/infrastructure/model/error/database_initialization_error.dart';
import 'package:location_logger/infrastructure/model/exception/database_insert_exception.dart';
import 'package:location_logger/infrastructure/model/exception/database_query_exception.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  final Task<Database> _database;

  DatabaseClient(String databaseName, int version)
      : _database = _initializeDatabase(databaseName, version);

  static Task<Database> _initializeDatabase(String databaseName, int version) {
    return Task(
      () async {
        try {
          return await openDatabase(
            databaseName,
            version: version,
            onCreate: _createTables,
          );
        } catch (error) {
          throw DatabaseInitializationError(error);
        }
      },
    );
  }

  static Future<void> _createTables(Database database, int version) {
    return database.execute('''
      CREATE TABLE Location (
        timestamp INTEGER NOT NULL PRIMARY KEY,
        latitude TEXT NOT NULL,
        longitude TEXT NOT NULL,
        altitude TEXT NOT NULL,
        speed TEXT
      ) WITHOUT ROWID
    ''');
  }

  TaskEither<DatabaseInsertException, void> insert(
    String query,
    List<Object?> arguments,
  ) {
    return _database
        .toTaskEither<DatabaseInsertException>()
        .flatMap(
          (database) => TaskEither.tryCatch(
            () => database.rawInsert(query, arguments),
            (error, stackTrace) => DatabaseInsertException(error),
          ),
        )
        .filterOrElse((result) => result > 0,
            (result) => DatabaseInsertException("Failed insertion"))
        .map<void>((_) => {});
  }

  TaskEither<DatabaseQueryException, List<Map<String, Object?>>> query<T>(
    String query,
    List<Object?> arguments,
  ) {
    return _database.toTaskEither<DatabaseQueryException>().flatMap(
          (database) => TaskEither.tryCatch(
            () => database.rawQuery(query, arguments),
            (error, stackTrace) => DatabaseQueryException(error),
          ),
        );
  }
}
