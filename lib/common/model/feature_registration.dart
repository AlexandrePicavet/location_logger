import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
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
  Future<void> register<T extends Object>(
    T serviceRegistration, {
    String? serviceName,
    DisposingFunc<T>? dispose,
  }) async {
    if (serviceLocator.isRegistered<T>(instanceName: serviceName)) {
      return;
    }
    serviceLocator.registerSingleton(
      serviceRegistration,
      instanceName: serviceName,
      dispose: dispose,
    );
  }

  @protected
  Future<void> registerFuture<T extends Object>(
    Future<T> serviceRegistration, {
    String? serviceName,
    DisposingFunc<T>? dispose,
  }) async {
    register(
      await serviceRegistration,
      serviceName: serviceName,
      dispose: dispose,
    );
  }

  @protected
  Future<void> registerTask<T extends Object>(
    TaskEither<FeatureRegistrationError, T> service, {
    String? serviceName,
    DisposingFunc<T>? dispose,
  }) async {
    register<T>(
      await service.getOrElse((error) => throw error).run(),
      serviceName: serviceName,
      dispose: dispose,
    );
  }
}
