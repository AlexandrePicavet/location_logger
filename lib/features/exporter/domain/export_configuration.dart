import 'package:location_logger/features/exporter/domain/export_target.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';

class ExportConfiguration {
  final LocationDateTimeInterval exportInterval;
  final ExportTarget exportTarget;

  ExportConfiguration({
    required this.exportInterval,
    required this.exportTarget,
  });
}
