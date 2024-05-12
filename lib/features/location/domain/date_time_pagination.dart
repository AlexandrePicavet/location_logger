import 'package:fpdart/fpdart.dart';

class DateTimePagination {
  static const defaultLimit = 100;

  final DateTime? start;
  final DateTime? end;
  final int offset;
  // A null limit will return all items
  final int? limit;

  DateTimePagination.between({
    required this.start,
    required this.end,
    this.offset = 0,
    this.limit = defaultLimit,
  }) {
    _checkIntegrity();
  }

  DateTimePagination.before({
    required this.end,
    this.offset = 0,
    this.limit = defaultLimit,
  }) : start = null {
    _checkIntegrity();
  }

  DateTimePagination.after({
    required this.start,
    this.offset = 0,
    this.limit = defaultLimit,
  }) : end = null {
    _checkIntegrity();
  }

  DateTimePagination._({
    required this.start,
    required this.end,
    required this.offset,
    required this.limit,
  });

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
          offset, "offset", "must be greater or equal to 0");
    }
    if (limit != null && limit! <= offset) {
      throw ArgumentError.value(
          limit, "limit", "must be greater than offset ($offset)");
    }
  }

  Option<DateTimePagination> next(int? limit) {
    return Option.fromNullable(this.limit).map(
      (currentLimit) => DateTimePagination._(
        start: start,
        end: end,
        offset: offset + currentLimit,
        limit: limit ?? currentLimit,
      ),
    );
  }
}
