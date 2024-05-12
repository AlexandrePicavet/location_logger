import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/application/port/location_gathering_port.dart';
import 'package:location_logger/features/location/application/port/location_persistence_port.dart';
import 'package:location_logger/features/location/application/port/location_retrieval_port.dart';
import 'package:location_logger/features/location/application/usecase/list_locations_usecase.dart';
import 'package:location_logger/features/location/application/usecase/register_location_usecase.dart';
import 'package:location_logger/features/location/domain/date_time_paginated_list.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';
import 'package:location_logger/features/location/domain/error/list_location_error.dart';
import 'package:location_logger/features/location/domain/error/location_update_error.dart';
import 'package:location_logger/features/location/domain/location.dart';

class LocationService
    implements RegisterCurrentLocationUsecase, LocationsListUsecase {
  final LocationGatheringPort locationGatheringPort;
  final LocationPersistencePort locationPersistencePort;
  final LocationRetrievalPort locationsListPort;

  LocationService({
    required this.locationGatheringPort,
    required this.locationPersistencePort,
    required this.locationsListPort,
  });

  @override
  TaskEither<LocationUpdateError, void> register() {
    return locationGatheringPort()
        .map(locationPersistencePort.persist)
        .mapLeft(LocationUpdateError.new);
  }

  @override
  TaskEither<ListLocationError, DateTimePaginatedList<Location>> list(
    DateTimePagination pagination,
  ) {
    return locationsListPort.list(pagination).mapLeft(ListLocationError.new);
  }
}
