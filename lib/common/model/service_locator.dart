import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

extension GetOrRegister on GetIt {
  S getOrRegister<S extends Object>({
    required S Function() initializer,
    String? instanceName,
  }) =>
      isRegistered<S>(instanceName: instanceName)
          ? this()
          : registerSingleton<S>(initializer(), instanceName: instanceName);
}
