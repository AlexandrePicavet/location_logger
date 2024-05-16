import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:location_logger/common/model/exception/location_logger_exception.dart';

final serviceLocator = GetIt.instance;

extension GetOrRegister on GetIt {
  TaskEither<LocationLoggerException, S> getOrRegister<S extends Object>({
    required TaskEither<LocationLoggerException, S> Function() initializer,
    String? instanceName,
  }) =>
      isRegistered<S>(instanceName: instanceName)
          ? TaskEither.right(this())
          : initializer().map(
              (service) =>
                  registerSingleton<S>(service, instanceName: instanceName),
            );
}
