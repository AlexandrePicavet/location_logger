import 'package:location_logger/common/model/feature_registration.dart';
import 'package:location_logger/features/location/location_feature_registration.dart';

class RegisterFeatures extends FeatureRegistration {
  final List<FeatureRegistration> features = [
    LocationFeatureRegistration(),
  ];

  @override
  List<Future<void> Function()> get registrations => features
      .map((feature) => feature().getOrElse((error) => throw error).run)
      .toList();
}
