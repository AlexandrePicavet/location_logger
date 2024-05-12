import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_retrieval_exception.dart';
import 'package:location_logger/features/location/domain/date_time_paginated_list.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';
import 'package:location_logger/features/location/domain/location.dart';

abstract class LocationRetrievalPort {
  TaskEither<LocationRetrievalException, DateTimePaginatedList<Location>> list(
    DateTimePagination pagination,
  );
}
