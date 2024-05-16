import 'package:location_logger/common/model/feature_registration.dart';
import 'package:location_logger/common/model/service_locator.dart';
import 'package:location_logger/features/exporter/adapter/location_exporter_factory_adapter.dart';
import 'package:location_logger/features/exporter/application/port/location_exporter_factory_port.dart';
import 'package:location_logger/features/exporter/application/service/export_location_service.dart';
import 'package:location_logger/features/exporter/application/usecase/export_location_usecase.dart';

class ExporterFeatureRegistration extends FeatureRegistration {
  @override
  List<Future<void> Function()> get registrations => [
        _registerExporterFactoryAdapter,
        _registerExporterFactoryPort,
        _registerExportLocationService,
        _registerExportLocationUsecase,
      ];

  Future<void> _registerExporterFactoryAdapter() async {
    return register(LocationExporterFactoryAdapter());
  }

  Future<void> _registerExporterFactoryPort() {
    return register<LocationExporterFactoryPort>(
      serviceLocator<LocationExporterFactoryAdapter>(),
    );
  }

  Future<void> _registerExportLocationService() {
    return register<ExportLocationService>(
      ExportLocationService(
        serviceLocator(),
        serviceLocator(),
      ),
    );
  }

  Future<void> _registerExportLocationUsecase() {
    return register<ExportLocationUsecase>(
      serviceLocator<ExportLocationService>(),
    );
  }
}
