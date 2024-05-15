import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/direction.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';

class DateTimePagination extends LocationDateTimeInterval {
  static const defaultLimit = 100;
  static const defaultDirection = Direction.desc;

  final int offset;
  // A null limit will return all items
  final int? limit;
  final Direction direction;

  DateTimePagination.between({
    required super.start,
    required super.end,
    this.offset = 0,
    this.limit = defaultLimit,
    this.direction = defaultDirection,
  }) : super.between() {
    _checkIntegrity();
  }

  DateTimePagination.before({
    required super.end,
    this.offset = 0,
    this.limit = defaultLimit,
    this.direction = defaultDirection,
  }) : super.before() {
    _checkIntegrity();
  }

  DateTimePagination.after({
    required super.start,
    this.offset = 0,
    this.limit = defaultLimit,
    this.direction = defaultDirection,
  }) : super.after() {
    _checkIntegrity();
  }

  DateTimePagination.from({
    required LocationDateTimeInterval interval,
    this.offset = 0,
    this.limit = defaultLimit,
    this.direction = defaultDirection,
  }) : super.between(start: interval.start, end: interval.end) {
    _checkIntegrity();
  }

  DateTimePagination._({
    required super.start,
    required super.end,
    required this.offset,
    required this.limit,
    required this.direction,
  }) : super.between() {
    _checkIntegrity();
  }

  Never? _checkIntegrity() {
    if (offset < 0) {
      throw ArgumentError.value(
        offset,
        "offset",
        "must be greater or equal to 0",
      );
    }
    if (limit != null && limit! <= offset) {
      throw ArgumentError.value(
        limit,
        "limit",
        "must be greater than offset ($offset)",
      );
    }
  }

  Option<DateTimePagination> next(int? limit) {
    return Option.fromNullable(this.limit).map(
      (currentLimit) => DateTimePagination._(
        start: start,
        end: end,
        offset: offset + currentLimit,
        limit: limit ?? currentLimit,
        direction: direction,
      ),
    );
  }
}
