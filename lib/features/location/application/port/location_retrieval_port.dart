import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/application/port/model/error/location_retrieval_error.dart';
import 'package:location_logger/features/location/domain/date_time_paginated_list.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';
import 'package:location_logger/features/location/domain/location.dart';

abstract class LocationRetrievalPort {
  TaskEither<LocationRetrievalError, DateTimePaginatedList<Location>> list(
    DateTimePagination pagination,
  );
}
