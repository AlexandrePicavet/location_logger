import 'package:location_logger/features/exporter/domain/export_target.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';

class ExportConfiguration {
  final ExportTarget exportTarget;
  final LocationDateTimeInterval exportInterval;

  ExportConfiguration({
    required this.exportTarget,
    required this.exportInterval,
  });
}
