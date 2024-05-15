import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/location.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';
import 'package:location_logger/infrastructure/exporter/model/exception/exiftool_exporter_export_exception.dart';
import 'package:location_logger/infrastructure/exporter/model/exception/exiftool_exporter_initialization_exception.dart';
import 'package:permission_handler/permission_handler.dart';

class ExiftoolExporterClient {
  static const gpsTags = [
    "GPSTimeStamp",
    "GPSLatitude",
    "GPSLongitude",
    "GPSAltitude",
    "GPSSpeed",
  ];

  static const refTags = [
    "GPSLatitudeRef",
    "GPSLongitudeRef",
    "GPSAltitudeRef",
    "GSPSpeedRef",
  ];

  static const refs = ["N", "W", "0", "K"];

  static const headers = [...gpsTags, ...refTags];

  TaskEither<ExiftoolExporterInitializationException, ExiftoolExporterClient>
      initialize() {
    return TaskEither.tryCatch(
      () async {
        await _requestStoragePermission();

        return this;
      },
      (error, stackTrace) => ExiftoolExporterInitializationException(error),
    );
  }

  TaskEither<ExiftoolExporterExportException, void> export(
    List<Location> locations,
    LocationDateTimeInterval interval,
  ) {
    return getExportPath(interval).flatMap(
      (filename) => _map(locations).toTaskEither().flatMap(
            (data) => _save(data, filename),
          ),
    );
  }

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return;
    }

    final permission = Permission.storage.onPermanentlyDeniedCallback(
      () => throw ExiftoolExporterInitializationException(
        ExiftoolExporterInitializationExceptionCause
            .permissionPermanentlyDenied,
      ),
    );

    while (!(await permission.request().isGranted)) {}
  }

  TaskEither<ExiftoolExporterExportException, String> getExportPath(
    LocationDateTimeInterval interval,
  ) {
    return TaskEither.tryCatch(
      () async => Option.fromNullable(
        await FilePicker.platform.saveFile(
          allowedExtensions: ["csv"],
          fileName: 'location-export-${interval.toString()}',
        ),
      ).getOrElse(() => throw "Export cancelled"),
      (error, stackTrace) => ExiftoolExporterExportException(error),
    );
  }

  Either<ExiftoolExporterExportException, String> _map(
    List<Location> locations,
  ) {
    final data = locations.map(_mapLocation);

    return Either.tryCatch(
      () => const ListToCsvConverter().convert([headers, ...data]),
      (error, stackTrace) => ExiftoolExporterExportException(error),
    );
  }

  List<dynamic> _mapLocation(Location location) {
    final timestamp = location.dateTime.toString(); // change
    final speedInKMph = Option.fromNullable(location.speed)
        .map((speed) => (speed * 3.6))
        .toNullable();

    return [
      timestamp,
      location.latitude,
      location.longitude,
      location.altitude,
      speedInKMph,
      ...refs
    ];
  }

  TaskEither<ExiftoolExporterExportException, void> _save(
    String csvData,
    String filename,
  ) {
    return TaskEither.tryCatch(
      () async {
        final output = File(filename).openWrite();

        output.write(csvData);

        await output.flush();
        await output.close();
      },
      (error, stackTrace) => ExiftoolExporterExportException(error),
    );
  }
}
