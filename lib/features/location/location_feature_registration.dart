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
import 'package:location_logger/infrastructure/database_client.dart';
import 'package:location_logger/infrastructure/location_client.dart';

class LocationFeatureRegistration extends FeatureRegistration {
  @override
  List<Future<void> Function()> get registrations => [
        registerDatabaseClient,
        registerLocationClient,
        registerLocationDatabaseAdapter,
        registerLocationGatheringAdapter,
        registerLocationPersistencePort,
        registerLocationRetrievalPort,
        registerLocationGatheringPort,
        registerLocationService,
        registerRegisterCurrentLocationUsecase,
        registerLocationsListUsecase
      ];

  Future<void> registerDatabaseClient() {
    final client = DatabaseClient(name: "location", version: 1)
        .initialize(
          onOpen: (db) => db.execute('''
            CREATE TABLE IF NOT EXISTS Location (
              timestamp INTEGER NOT NULL PRIMARY KEY,
              latitude TEXT NOT NULL,
              longitude TEXT NOT NULL,
              altitude TEXT NOT NULL,
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

  Future<void> registerLocationClient() {
    final client =
        LocationClient().initialize().mapLeft(FeatureRegistrationError.new);

    return registerTask<LocationClient>(client);
  }

  Future<void> registerLocationDatabaseAdapter() {
    return register(LocationDatabaseAdapter(
      serviceLocator<DatabaseClient>(instanceName: "locationDatabase"),
    ));
  }

  Future<void> registerLocationGatheringAdapter() {
    return register<LocationGatheringAdapter>(
      LocationGatheringAdapter(serviceLocator()),
    );
  }

  Future<void> registerLocationPersistencePort() {
    return register<LocationPersistencePort>(
      serviceLocator<LocationDatabaseAdapter>(),
    );
  }

  Future<void> registerLocationRetrievalPort() {
    return register<LocationRetrievalPort>(
      serviceLocator<LocationDatabaseAdapter>(),
    );
  }

  Future<void> registerLocationGatheringPort() {
    return register<LocationGatheringPort>(
      serviceLocator<LocationGatheringAdapter>(),
    );
  }

  Future<void> registerLocationService() {
    return register<LocationService>(LocationService(
      locationGatheringPort: serviceLocator(),
      locationPersistencePort: serviceLocator(),
      locationsRetrievalPort: serviceLocator(),
    ));
  }

  Future<void> registerRegisterCurrentLocationUsecase() async {
    await register<RegisterLocationUpdatesUsecase>(
      serviceLocator<LocationService>(),
    );

    serviceLocator<RegisterLocationUpdatesUsecase>().registerUpdates();
  }

  Future<void> registerLocationsListUsecase() {
    return register<LocationsListUsecase>(
      serviceLocator<LocationService>(),
    );
  }
}
