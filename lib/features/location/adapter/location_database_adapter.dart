import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/adapter/model/mapper/date_time_pagination_to_sql.dart';
import 'package:location_logger/features/location/adapter/model/mapper/map_to_location.dart';
import 'package:location_logger/features/location/application/port/location_persistence_port.dart';
import 'package:location_logger/features/location/application/port/location_retrieval_port.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_persistence_exception.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_retrieval_exception.dart';
import 'package:location_logger/features/location/domain/date_time_paginated_list.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';
import 'package:location_logger/features/location/domain/location.dart';
import 'package:location_logger/infrastructure/database/database_client.dart';

class LocationDatabaseAdapter
    implements LocationPersistencePort, LocationRetrievalPort {
  final DatabaseClient databaseClient;

  LocationDatabaseAdapter(this.databaseClient);

  @override
  TaskEither<LocationPersistenceException, void> persist(Location location) {
    return databaseClient.insert(
      "INSERT INTO Location(timestamp, latitude, longitude, altitude, speed) VALUES (?, ?, ?, ?, ?)",
      [
        location.dateTime.millisecondsSinceEpoch,
        location.latitude,
        location.longitude,
        location.altitude,
        location.speed
      ],
    ).mapLeft(LocationPersistenceException.new);
  }

  @override
  TaskEither<LocationRetrievalException, DateTimePaginatedList<Location>> list(
    DateTimePagination pagination,
  ) {
    return databaseClient.query(
      '''
        SELECT timestamp, latitude, longitude, altitude, speed
        FROM Location
        ${pagination.toWhereOrderByOffsetLimit()}
      ''',
      [],
    ).bimap(
      LocationRetrievalException.new,
      (results) => DateTimePaginatedList(
        list: results.map((resultItem) => resultItem.toLocation()).toList(),
        pagination: pagination,
      ),
    );
  }
}
