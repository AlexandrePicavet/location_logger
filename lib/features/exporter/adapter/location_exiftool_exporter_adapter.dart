import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/exporter/application/port/location_exporter_port.dart';
import 'package:location_logger/features/exporter/application/port/model/location_exportation_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';
import 'package:location_logger/infrastructure/exporter/exiftool_exporter_client.dart';

class LocationExiftoolExporterAdapter implements LocationExporterPort {
  final ExiftoolExporterClient client;

  LocationExiftoolExporterAdapter(this.client);

  @override
  TaskEither<LocationExportationException, void> export(
    List<Location> locations,
    LocationDateTimeInterval interval,
  ) {
    return client
        .export(locations, interval)
        .mapLeft(LocationExportationException.new);
  }
}
