import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/exporter/application/port/location_exporter_factory_port.dart';
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
    return _list(configuration.exportInterval)
        .flatMap((locations) => _export(locations, configuration));
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

  TaskEither<ExportLocationException, void> _export(
    List<Location> locations,
    ExportConfiguration configuration,
  ) {
    return exporterFactoryPort
        .get(configuration.exportTarget)
        .mapLeft(ExportLocationException.new)
        .flatMap(
          (exporter) => exporter
              .export(locations, configuration.exportInterval)
              .mapLeft(ExportLocationException.new),
        );
  }
}
