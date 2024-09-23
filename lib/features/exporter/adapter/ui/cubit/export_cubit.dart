import 'package:bloc/bloc.dart';
import 'package:location_logger/common/adapter/ui/cubit/cubit_state.dart';
import 'package:location_logger/common/adapter/ui/cubit/error_state.dart';
import 'package:location_logger/common/model/service_locator.dart';
import 'package:location_logger/features/exporter/application/usecase/export_location_usecase.dart';
import 'package:location_logger/features/exporter/domain/exception/export_location_exception.dart';
import 'package:location_logger/features/exporter/domain/export_configuration.dart';
import 'package:location_logger/features/exporter/domain/export_target.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  final ExportLocationUsecase usecase;

  ExportCubit()
      : usecase = serviceLocator(),
        super(const InitialExportState());

  void setExportTarget(ExportTarget exportTarget) {
    final currentState = state;

    return switch (currentState) {
      ExportTargetConfigurationExportState() || InitialExportState() => emit(
          ExportTargetConfigurationExportState(exportTarget),
        ),
      LocationDateTimeIntervalConfigurationExportState() => emit(
          LocationDateTimeIntervalConfigurationExportState(
            exportTarget,
            currentState.exportInterval,
          ),
        ),
      ExportedState() => emit(
          LocationDateTimeIntervalConfigurationExportState(
            exportTarget,
            currentState.configuration.exportInterval,
          ),
        ),
      _ => throw StateError(
          "'setExportTarget' method can only be called when 'state' is 'ExportTargetConfigurationExportState', 'LocationDateTimeIntervalConfigurationExportState' or 'ExportedState'",
        )
    };
  }

  void selectExportInterval(LocationDateTimeInterval exportInterval) {
    final currentState = state;

    emit(
      switch (currentState) {
        ExportTargetConfigurationExportState() ||
        LocationDateTimeIntervalConfigurationExportState() =>
          LocationDateTimeIntervalConfigurationExportState(
            (currentState as dynamic).exportTarget,
            exportInterval,
          ),
        ExportedState() => LocationDateTimeIntervalConfigurationExportState(
            currentState.configuration.exportTarget,
            exportInterval,
          ),
        _ => throw StateError(
            "'selectExportInterval' method can only be called when 'state' is 'ExportTargetConfigurationExportState', 'LocationDateTimeIntervalConfigurationExportState' or 'ExportedState'",
          )
      },
    );
  }

  void export() async {
    final currentState = state;
    final newState = switch (currentState) {
      LocationDateTimeIntervalConfigurationExportState() => ExportingState(
          ExportConfiguration(
            exportTarget: currentState.exportTarget,
            exportInterval: currentState.exportInterval,
          ),
        ),
      ExportedState() => ExportingState(currentState.configuration),
      _ => throw StateError(
          "'export' method can only be called when 'state' is 'LocationDateTimeIntervalConfigurationExportState' or 'ExportedState'",
        )
    };

    emit(newState);

    // TODO Fix export stuck (Not really stuck, often the handling in the widget is not working)
    final future = usecase.export(newState.configuration);
    final result = await future.run();

    return result.fold(
      (error) => emit(ExportingErrorState(error)),
      (_) => emit(ExportedState(newState.configuration)),
    );
  }
}
