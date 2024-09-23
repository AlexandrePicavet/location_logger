import 'package:fpdart/fpdart.dart';
import 'package:location_logger/infrastructure/database/model/error/database_initialization_error.dart';
import 'package:location_logger/infrastructure/database/model/exception/database_insert_exception.dart';
import 'package:location_logger/infrastructure/database/model/exception/database_path_exception.dart';
import 'package:location_logger/infrastructure/database/model/exception/database_query_exception.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  final String name;
  final int version;

  late final Database _database;

  DatabaseClient({required this.name, required this.version});

  TaskEither<DatabaseInitializationError, DatabaseClient> initialize({
    OnDatabaseCreateFn? onCreate,
    OnDatabaseOpenFn? onOpen,
    OnDatabaseVersionChangeFn? onUpgrade,
    OnDatabaseVersionChangeFn? onDowngrade,
  }) {
    return TaskEither.tryCatch(
      () async {
        _database = await openDatabase(
          name,
          version: version,
          onCreate: onCreate,
          onOpen: onOpen,
          onUpgrade: onUpgrade,
          onDowngrade: onDowngrade,
        );

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
    ).map<void>((_) => {});
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

  TaskEither<DatabasePathException, String> getPath() {
    return TaskEither.tryCatch(
      () async => _database.path,
      (error, stackTrace) => DatabasePathException(error),
    );
  }
}
