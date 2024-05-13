import 'package:fpdart/fpdart.dart';
import 'package:location_logger/features/location/adapter/model/mapper/location_data_to_location.dart';
import 'package:location_logger/features/location/application/port/location_gathering_port.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_gathering_exception.dart';
import 'package:location_logger/features/location/domain/location.dart';
import 'package:location_logger/infrastructure/location_client.dart';

class LocationGatheringAdapter implements LocationGatheringPort {
  final LocationClient locationClient;

  LocationGatheringAdapter(this.locationClient);

  @override
  TaskEither<LocationGatheringException, Location> call() {
    return locationClient
        .getLocation()
        .mapLeft(LocationGatheringException.new)
        .chainEither(
          (locationData) => locationData.toLocation().toEither(
                () => LocationGatheringException(
                  "Missing data from the location data",
                ),
              ),
        );
  }
}
