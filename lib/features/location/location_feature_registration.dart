import 'dart:async';
import 'package:location_logger/common/model/error/feature_registration_error.dart';
import 'package:location_logger/common/model/feature_registration.dart';
import 'package:location_logger/common/model/service_locator.dart';
import 'package:location_logger/features/location/adapter/location_database_adapter.dart';
import 'package:location_logger/features/location/adapter/location_gathering_adapter.dart';
import 'package:location_logger/features/location/application/port/location_gathering_port.dart';
import 'package:location_logger/features/location/application/port/location_persistence_port.dart';
import 'package:location_logger/features/location/application/port/location_retrieval_port.dart';
import 'package:location_logger/features/location/application/service/location_service.dart';
import 'package:location_logger/features/location/application/usecase/locations_list_usecase.dart';
import 'package:location_logger/features/location/application/usecase/register_location_updates_usecase.dart';
import 'package:location_logger/infrastructure/database/database_client.dart';
import 'package:location_logger/infrastructure/android/location_client.dart';

class LocationFeatureRegistration extends FeatureRegistration {
  @override
  List<Future<void> Function()> get registrations => [
        _registerDatabaseClient,
        _registerLocationClient,
        _registerLocationDatabaseAdapter,
        _registerLocationGatheringAdapter,
        _registerLocationPersistencePort,
        _registerLocationRetrievalPort,
        _registerLocationGatheringPort,
        _registerLocationService,
        _registerRegisterCurrentLocationUsecase,
        _registerLocationsListUsecase
      ];

  Future<void> _registerDatabaseClient() {
    final client = DatabaseClient(name: "location", version: 30)
        .initialize(
          onOpen: (db) => db.execute('''
            CREATE TABLE IF NOT EXISTS Location (
              timestamp INTEGER NOT NULL PRIMARY KEY,
              latitude TEXT NOT NULL,
              longitude TEXT NOT NULL,
              altitude TEXT,
              speed TEXT
            ) WITHOUT ROWID
          '''),
        )
        .mapLeft(FeatureRegistrationError.new);

    return registerTask(
      client,
      serviceName: "locationDatabase",
    );
  }

  Future<void> _registerLocationClient() {
    final client =
        LocationClient().initialize().mapLeft(FeatureRegistrationError.new);

    return registerTask<LocationClient>(client);
  }

  Future<void> _registerLocationDatabaseAdapter() {
    return register(LocationDatabaseAdapter(
      serviceLocator<DatabaseClient>(instanceName: "locationDatabase"),
    ));
  }

  Future<void> _registerLocationGatheringAdapter() {
    return register<LocationGatheringAdapter>(
      LocationGatheringAdapter(serviceLocator()),
    );
  }

  Future<void> _registerLocationPersistencePort() {
    return register<LocationPersistencePort>(
      serviceLocator<LocationDatabaseAdapter>(),
    );
  }

  Future<void> _registerLocationRetrievalPort() {
    return register<LocationRetrievalPort>(
      serviceLocator<LocationDatabaseAdapter>(),
    );
  }

  Future<void> _registerLocationGatheringPort() {
    return register<LocationGatheringPort>(
      serviceLocator<LocationGatheringAdapter>(),
    );
  }

  Future<void> _registerLocationService() {
    return register<LocationService>(LocationService(
      locationGatheringPort: serviceLocator(),
      locationPersistencePort: serviceLocator(),
      locationsRetrievalPort: serviceLocator(),
    ));
  }

  Future<void> _registerRegisterCurrentLocationUsecase() async {
    await register<RegisterLocationUpdatesUsecase>(
      serviceLocator<LocationService>(),
    );

    serviceLocator<RegisterLocationUpdatesUsecase>().registerUpdates();
  }

  Future<void> _registerLocationsListUsecase() {
    return register<LocationsListUsecase>(
      serviceLocator<LocationService>(),
    );
  }
}
