import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/exporter/application/port/location_exporter_factory_port.dart';
import 'package:location_logger/features/exporter/application/port/location_exporter_port.dart';
import 'package:location_logger/features/exporter/application/usecase/export_location_usecase.dart';
import 'package:location_logger/features/exporter/domain/exception/export_location_exception.dart';
import 'package:location_logger/features/exporter/domain/export_configuration.dart';
import 'package:location_logger/features/location/application/usecase/locations_list_usecase.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';
import 'package:location_logger/features/location/domain/location.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';

class ExportLocationService implements ExportLocationUsecase {
  final LocationsListUsecase listUsecase;
  final LocationExporterFactoryPort exporterFactoryPort;

  ExportLocationService(this.listUsecase, this.exporterFactoryPort);

  @override
  TaskEither<ExportLocationException, void> export(
    ExportConfiguration configuration,
  ) {
    return _selectExporter(configuration)
        .flatMap(
          (exporter) => _list(configuration.exportInterval)
              .map((locations) => (exporter, locations)),
        )
        .flatMap(
          (tuple) => _export(tuple.$1, tuple.$2, configuration.exportInterval),
        );
  }

  TaskEither<ExportLocationException, List<Location>> _list(
      LocationDateTimeInterval exportInterval) {
    final pagination = DateTimePagination.from(
      interval: exportInterval,
      offset: 0,
      limit: null,
    );

    return listUsecase.list(pagination).bimap(
          ExportLocationException.new,
          (locations) => locations.list,
        );
  }

  TaskEither<ExportLocationException, LocationExporterPort> _selectExporter(
    ExportConfiguration configuration,
  ) {
    return exporterFactoryPort
        .get(configuration.exportTarget)
        .mapLeft(ExportLocationException.new);
  }

  TaskEither<ExportLocationException, void> _export(
    LocationExporterPort exporter,
    List<Location> locations,
    LocationDateTimeInterval exportInterval,
  ) {
    return exporter
        .export(locations, exportInterval)
        .mapLeft(ExportLocationException.new);
  }
}
