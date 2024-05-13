import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_logger/common/model/error/feature_registration_error.dart';
import 'package:location_logger/common/model/service_locator.dart';

abstract class FeatureRegistration {
  @protected
  abstract final List<Future<void> Function()> registrations;

  TaskEither<FeatureRegistrationError, void> call() {
    return TaskEither.tryCatch(
      () async {
        for (final registration in registrations) {
          await registration();
        }
      },
      (error, stackTrace) => FeatureRegistrationError(error),
    );
  }

  @protected
  Future<void> register<T extends Object>(T serviceRegistration,
      {String? serviceName}) async {
    if (serviceLocator.isRegistered<T>(instanceName: serviceName)) {
      return;
    }
    serviceLocator.registerSingleton(
      serviceRegistration,
      instanceName: serviceName,
    );
  }

  @protected
  Future<void> registerFuture<T extends Object>(Future<T> serviceRegistration,
      {String? serviceName}) async {
    register(
      await serviceRegistration,
      serviceName: serviceName,
    );
  }

  @protected
  Future<void> registerTask<T extends Object>(
      TaskEither<FeatureRegistrationError, T> service,
      {String? serviceName}) async {
    register<T>(
      await service.getOrElse((error) => throw error).run(),
      serviceName: serviceName,
    );
  }
}
