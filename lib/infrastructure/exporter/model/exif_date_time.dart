import 'package:location_logger/common/model/int_extension.dart';

extension ExifDateTime on DateTime {
  String toExif() {
    final utc = toUtc();

    return [
      [utc.year.toString(), utc.month.digits(2), utc.day.digits(2)],
      [utc.hour.digits(2), utc.minute.digits(2), utc.second.digits(2)]
    ].map((parts) => parts.join(":")).join(" ");
  }
}
