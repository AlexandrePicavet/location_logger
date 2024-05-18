import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/location.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';
import 'package:location_logger/infrastructure/exporter/model/exception/exiftool_exporter_export_exception.dart';
import 'package:location_logger/infrastructure/exporter/model/exception/exiftool_exporter_initialization_exception.dart';
import 'package:location_logger/infrastructure/exporter/model/exif_date_time.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// https://exiftool.org/geotag.html
class ExiftoolExporterClient {
  static const gpsTags = [
    "GPSDateTime",
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
  static const headers = [...gpsTags, ...refTags];

  static const refs = ["N", "W", "0", "K"];

  TaskEither<ExiftoolExporterInitializationException, ExiftoolExporterClient>
      initialize() {
    return TaskEither.tryCatch(
      () async {
        //await _requestStoragePermission();

        return this;
      },
      (error, stackTrace) => ExiftoolExporterInitializationException(error),
    );
  }

  TaskEither<ExiftoolExporterExportException, void> export(
    List<Location> locations,
    LocationDateTimeInterval interval,
  ) {
    return _map(locations)
        .toTaskEither()
        .flatMap(
          (data) => _save(data, "location-export--${interval.toString()}.csv"),
        )
        .flatMap(_export);
  }

  Either<ExiftoolExporterExportException, String> _map(
    List<Location> locations,
  ) {
    return Either.tryCatch(
      () => const ListToCsvConverter().convert([
        headers,
        ...locations.map(_mapLocationToCsvData),
      ]),
      (error, stackTrace) => ExiftoolExporterExportException(error),
    );
  }

  List<dynamic> _mapLocationToCsvData(Location location) {
    final speedInKMph = Option.fromNullable(location.speed)
        .map((speed) => (speed * 3.6))
        .toNullable();

    return [
      location.dateTime.toExif(),
      location.latitude,
      location.longitude,
      location.altitude,
      speedInKMph,
      ...refs
    ];
  }

  TaskEither<ExiftoolExporterExportException, File> _save(
    String csvData,
    String filename,
  ) {
    return TaskEither.tryCatch(
      () async {
        var file = File("${(await getTemporaryDirectory()).path}/$filename");
        if (!(await file.exists())) {
          file = await file.create();
        }

        final output = file.openWrite()..write(csvData);
        await output.flush();
        await output.close();

        return file;
      },
      (error, stackTrace) => ExiftoolExporterExportException(error),
    );
  }

  TaskEither<ExiftoolExporterExportException, void> _export(File file) {
    return TaskEither.tryCatch(
      () async {
        final result = await Share.shareXFiles(
          [XFile(file.path, mimeType: "text/csv")],
          text: "Exiftool GeoTag Locations",
        );

        if (result.status != ShareResultStatus.success) {
          throw ExiftoolExporterExportException(result);
        }
      },
      (error, stackTrace) => ExiftoolExporterExportException(error),
    );
  }
}
