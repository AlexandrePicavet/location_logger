import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart' show LocationData;
import 'package:location_logger/features/location/domain/location.dart'
    show Location;

extension LocationDataToLocation on LocationData {
  Option<Location> toLocation() {
    return Option.fromPredicateMap(
      this,
      _valid,
      (locationData) => Location(
        dateTime: DateTime.fromMicrosecondsSinceEpoch(time!.toInt()),
        latitude: latitude!,
        longitude: longitude!,
        altitude: altitude!,
        speed: speed,
      ),
    );
  }

  bool _valid(LocationData locationData) {
    return time != null &&
        latitude != null &&
        longitude != null &&
        altitude != null;
  }
}
