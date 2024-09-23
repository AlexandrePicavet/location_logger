import 'package:fpdart/fpdart.dart';
import 'package:location_logger/common/model/service_locator.dart';
import 'package:location_logger/features/exporter/adapter/location_database_exporter_adapter.dart';
import 'package:location_logger/features/exporter/adapter/location_exiftool_exporter_adapter.dart';
import 'package:location_logger/features/exporter/application/port/location_exporter_factory_port.dart';
import 'package:location_logger/features/exporter/application/port/location_exporter_port.dart';
import 'package:location_logger/features/exporter/application/port/model/error/location_exporter_selection_error.dart';
import 'package:location_logger/features/exporter/domain/export_target.dart';
import 'package:location_logger/infrastructure/exporter/database_exporter_client.dart';
import 'package:location_logger/infrastructure/exporter/exiftool_exporter_client.dart';

class LocationExporterFactoryAdapter implements LocationExporterFactoryPort {
  @override
  TaskEither<LocationExporterSelectionException, LocationExporterPort> get(
    ExportTarget exportTarget,
  ) =>
      switch (exportTarget) {
        ExportTarget.exifTool => serviceLocator
            .getOrRegister(initializer: _exifToolInitializer)
            .mapLeft(LocationExporterSelectionException.new),
        ExportTarget.database => serviceLocator
            .getOrRegister(initializer: _databaseInitializer)
            .mapLeft(LocationExporterSelectionException.new),
      };

  TaskEither<LocationExporterSelectionException,
      LocationExiftoolExporterAdapter> _exifToolInitializer() {
    return ExiftoolExporterClient().initialize().bimap(
          LocationExporterSelectionException.new,
          LocationExiftoolExporterAdapter.new,
        );
  }

  TaskEither<LocationExporterSelectionException,
      LocationDatabaseExporterAdapter> _databaseInitializer() {
    return DatabaseExporterClient().initialize().bimap(
          LocationExporterSelectionException.new,
          LocationDatabaseExporterAdapter.new,
        );
  }
}
