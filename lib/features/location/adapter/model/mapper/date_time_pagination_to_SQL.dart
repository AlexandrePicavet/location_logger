import 'package:location_logger/features/location/domain/date_time_pagination.dart';

extension DateTimePaginationToSQL on DateTimePagination {
  String toWhereOffsetLimit({String timestampColumnName = "timestamp"}) {
    return [
      toWhereClause(timestampColumnName: timestampColumnName),
      toOffsetLimit()
    ].join(" ");
  }

  String toWhereClause({String timestampColumnName = "timestamp"}) {
    String sql = "";

    if (start != null) {
      sql += "WHERE $timestampColumnName >= ${start!.millisecondsSinceEpoch}";

      if (end != null) {
        sql += " AND $timestampColumnName < ${end!.millisecondsSinceEpoch}";
      }
    } else if (end != null) {
      sql += "WHERE $timestampColumnName < ${end!.millisecondsSinceEpoch}";
    }

    return sql;
  }

  String toOffsetLimit() {
    String sql = "";

    if (offset > 0) {
      sql += "LIMIT $offset";

      if (limit != null) {
        sql += ", $limit";
      }
    } else if (limit != null) {
      sql += "LIMIT $limit";
    }

    return sql;
  }
}
