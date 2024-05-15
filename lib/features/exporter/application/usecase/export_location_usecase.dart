import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/exporter/domain/exception/export_location_exception.dart';
import 'package:location_logger/features/exporter/domain/export_configuration.dart';

abstract class ExportLocationUsecase {
  TaskEither<ExportLocationException, void> export(
    ExportConfiguration configuration,
  );
}
