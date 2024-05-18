import 'package:fpdart/fpdart.dart';
import 'package:location_logger/common/model/int_extension.dart';

class LocationDateTimeInterval {
  final DateTime? start;
  final DateTime? end;

  LocationDateTimeInterval.between({required this.start, required this.end});

  LocationDateTimeInterval.before({required this.end}) : start = null;

  LocationDateTimeInterval.after({required this.start}) : end = null;

  @override
  String toString() {
    final start = this.start;
    final end = this.end;

    return switch (start) {
      DateTime() => "from-${_dateTimeToString(start)}${switch (end) {
          DateTime() => "-to-${_dateTimeToString(end)}",
          null => "",
        }}",
      null => switch (end) {
          DateTime() => "to-${_dateTimeToString(end)}",
          null => throw StateError(
              "Start and end date cannot be null at the same time",
            ),
        }
    };
  }

  String _dateTimeToString(DateTime dateTime) {
    return [_dateToString(dateTime), _timeToString(dateTime)]
        .filter((value) => int.parse(value) > 0)
        .join("_");
  }

  static String _dateToString(DateTime dateTime) {
    return "${dateTime.year}${dateTime.month.digits(2)}${dateTime.day.digits(2)}";
  }

  static String _timeToString(DateTime dateTime) {
    return "${dateTime.hour.digits(2)}${dateTime.minute.digits(2)}${dateTime.second.digits(2)}";
  }
}
