import 'package:location_logger/features/location/domain/date_time_pagination.dart';

extension DateTimePaginationToSQL on DateTimePagination {
  static const defaultTimestampColumnName = "timestamp";

  String toWhereOrderByOffsetLimit({
    String timestampColumnName = defaultTimestampColumnName,
  }) {
    return [
      toWhereClause(timestampColumnName: timestampColumnName),
      toOrderBy(),
      toOffsetLimit(),
    ].join(" ");
  }

  String toWhereClause({
    String timestampColumnName = defaultTimestampColumnName,
  }) {
    return switch (start) {
      DateTime() =>
        "WHERE $timestampColumnName >= ${start!.millisecondsSinceEpoch}${switch (end) {
          DateTime() =>
            " AND $timestampColumnName < ${end!.millisecondsSinceEpoch}",
          null => "",
        }}",
      null => "WHERE $timestampColumnName < ${end!.millisecondsSinceEpoch}",
    };
  }

  String toOffsetLimit() {
    return switch (offset) {
      > 0 => "LIMIT $offset${switch (limit) {
          int() => ", $limit",
          null => "",
        }}",
      _ => switch (limit) {
          int() => "LIMIT $limit",
          null => "",
        }
    };
  }

  String toOrderBy({
    String timestampColumnName = defaultTimestampColumnName,
  }) {
    return "ORDER BY $timestampColumnName ${direction.name.toUpperCase()}";
  }
}
