import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/exporter/application/port/model/location_exportation_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';

abstract class LocationExporterPort {
  TaskEither<LocationExportationException, void> export(
    List<Location> locations,
    LocationDateTimeInterval interval,
  );
}
