import 'package:location_logger/common/model/int_extension.dart';

extension ExifDateTime on DateTime {
  String toExif() => [
        [year.toString(), month.digits(2), day.digits(2)],
        [hour.digits(2), minute.digits(2), second.digits(2)]
      ].map((parts) => parts.join(":")).join(" ");
}
