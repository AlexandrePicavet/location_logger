import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:location_logger/common/model/service_locator.dart';
import 'package:location_logger/features/exporter/domain/export_target.dart';
import 'package:location_logger/infrastructure/database/database_client.dart';
import 'package:location_logger/infrastructure/exporter/model/exception/database_exporter_export_exception.dart';
import 'package:location_logger/infrastructure/exporter/model/exception/database_exporter_initialization_exception.dart';
import 'package:share_plus/share_plus.dart';

class DatabaseExporterClient {
  static const target = ExportTarget.database;

  late final DatabaseClient _databaseClient;

  TaskEither<DatabaseExporterInitializationException, DatabaseExporterClient>
      initialize() {
    return TaskEither.tryCatch(
      () async {
        _databaseClient = serviceLocator.get(instanceName: "locationDatabase");

        return this;
      },
      (error, stackTrace) => DatabaseExporterInitializationException(error),
    );
  }

  TaskEither<DatabaseExporterExportException, void> export() {
    return _databaseClient
        .getPath()
        .map(File.new)
        .mapLeft(DatabaseExporterExportException.new)
        .flatMap(_export);
  }

  TaskEither<DatabaseExporterExportException, void> _export(File file) {
    return TaskEither.tryCatch(
      () async {
        final result = await Share.shareXFiles(
          [XFile(file.path, mimeType: "application/x-sqlite3")],
          text: target.label,
        );

        if (result.status != ShareResultStatus.success) {
          throw DatabaseExporterExportException(result);
        }
      },
      (error, stackTrace) => DatabaseExporterExportException(error),
    );
  }
}
