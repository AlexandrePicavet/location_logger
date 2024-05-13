import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/application/port/location_gathering_port.dart';
import 'package:location_logger/features/location/application/port/location_persistence_port.dart';
import 'package:location_logger/features/location/application/port/location_retrieval_port.dart';
import 'package:location_logger/features/location/application/usecase/locations_list_usecase.dart';
import 'package:location_logger/features/location/application/usecase/register_location_usecase.dart';
import 'package:location_logger/features/location/domain/date_time_paginated_list.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';
import 'package:location_logger/features/location/domain/exception/list_location_exception.dart';
import 'package:location_logger/features/location/domain/exception/location_update_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';

class LocationService
    implements RegisterCurrentLocationUsecase, LocationsListUsecase {
  final LocationGatheringPort locationGatheringPort;
  final LocationPersistencePort locationPersistencePort;
  final LocationRetrievalPort locationsRetrievalPort;

  LocationService({
    required this.locationGatheringPort,
    required this.locationPersistencePort,
    required this.locationsRetrievalPort,
  });

  @override
  TaskEither<LocationUpdateException, void> register() {
    return locationGatheringPort()
        .mapLeft(LocationUpdateException.new)
        .flatMap<void>(
          (location) => locationPersistencePort
              .persist(location)
              .mapLeft(LocationUpdateException.new),
        );
  }

  @override
  TaskEither<ListLocationException, DateTimePaginatedList<Location>> list(
    DateTimePagination pagination,
  ) {
    return locationsRetrievalPort
        .list(pagination)
        .mapLeft(ListLocationException.new);
  }
}
