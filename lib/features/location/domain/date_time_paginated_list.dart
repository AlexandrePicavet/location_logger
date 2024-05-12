import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';

class DateTimePaginatedList<T> {
  final List<T> list;
  final DateTimePagination pagination;

  DateTimePaginatedList({required this.list, required this.pagination});

  bool hasMore() {
    return Option.fromNullable(pagination.limit)
        .map((limit) => list.length >= limit)
        .getOrElse(() => false);
  }

  Option<DateTimePagination> nextPagination(int? limit) {
    return this.pagination.next(limit);
  }
}
