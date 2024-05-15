import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/exporter/application/port/location_exporter_port.dart';
import 'package:location_logger/features/exporter/application/port/model/error/location_exporter_selection_error.dart';
import 'package:location_logger/features/exporter/domain/export_target.dart';

abstract class LocationExporterFactoryPort {
  TaskEither<LocationExporterSelectionException, LocationExporterPort> get(
    ExportTarget exportTarget,
  );
}
