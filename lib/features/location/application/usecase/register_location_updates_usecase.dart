import 'dart:async';

import 'package:location_logger/features/location/domain/location.dart';

abstract class RegisterLocationUpdatesUsecase {
  StreamSubscription<Location> registerUpdates({
    Future<void> Function(Location)? onUpdate,
  });
}
