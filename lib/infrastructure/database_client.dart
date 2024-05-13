import 'package:fpdart/fpdart.dart';
import 'package:location_logger/infrastructure/model/error/database_initialization_error.dart';
import 'package:location_logger/infrastructure/model/exception/database_insert_exception.dart';
import 'package:location_logger/infrastructure/model/exception/database_query_exception.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  final String name;
  final int version;

  late final Database _database;

  DatabaseClient({required this.name, required this.version});

  TaskEither<DatabaseInitializationError, DatabaseClient> initialize({
    OnDatabaseCreateFn? onCreate,
    OnDatabaseOpenFn? onOpen,
  }) {
    return TaskEither.tryCatch(
      () async {
        _database = await openDatabase(name,
            version: version, onCreate: onCreate, onOpen: onOpen);

        return this;
      },
      (error, stackTrace) => DatabaseInitializationError(error),
    );
  }

  TaskEither<DatabaseInsertException, void> insert(
    String query,
    List<Object?> arguments,
  ) {
    return TaskEither.tryCatch(
      () => _database.rawInsert(query, arguments),
      (error, stackTrace) => DatabaseInsertException(error),
    )
        .filterOrElse(
          (result) => result > 0,
          (result) => DatabaseInsertException("Failed insertion"),
        )
        .map<void>((_) => {});
  }

  TaskEither<DatabaseQueryException, List<Map<String, Object?>>> query<T>(
    String query,
    List<Object?> arguments,
  ) {
    return TaskEither.tryCatch(
      () => _database.rawQuery(query, arguments),
      (error, stackTrace) => DatabaseQueryException(error),
    );
  }
}
