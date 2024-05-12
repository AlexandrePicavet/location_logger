import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/domain/date_time_paginated_list.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';
import 'package:location_logger/features/location/domain/error/list_location_error.dart';
import 'package:location_logger/features/location/domain/location.dart';

abstract class LocationsListUsecase {
  TaskEither<ListLocationError, DateTimePaginatedList<Location>> list(
    DateTimePagination pagination,
  );
}
