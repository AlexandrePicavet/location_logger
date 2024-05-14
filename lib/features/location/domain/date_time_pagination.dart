import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/direction.dart';

class DateTimePagination {
  static const defaultLimit = 100;
  static const defaultDirection = Direction.desc;

  final DateTime? start;
  final DateTime? end;
  final int offset;
  // A null limit will return all items
  final int? limit;
  final Direction direction;

  DateTimePagination.between({
    required this.start,
    required this.end,
    this.offset = 0,
    this.limit = defaultLimit,
    this.direction = defaultDirection,
  }) {
    _checkIntegrity();
  }

  DateTimePagination.before({
    required this.end,
    this.offset = 0,
    this.limit = defaultLimit,
    this.direction = defaultDirection,
  }) : start = null {
    _checkIntegrity();
  }

  DateTimePagination.after({
    required this.start,
    this.offset = 0,
    this.limit = defaultLimit,
    this.direction = defaultDirection,
  }) : end = null {
    _checkIntegrity();
  }

  DateTimePagination._({
    required this.start,
    required this.end,
    required this.offset,
    required this.limit,
    required this.direction,
  }) {
    _checkIntegrity();
  }

  Never? _checkIntegrity() {
    if (start == null && end == null) {
      throw ArgumentError("Either start or end must not be null");
    } else if (start != null && end != null && start!.second > end!.second) {
      throw ArgumentError(
        "End ($end) must be greater or equal to start ($start)",
      );
    }

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
