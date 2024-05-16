part of 'export_cubit.dart';

sealed class ExportState extends CubitState {
  final bool isExportTargetSelectable;
  final bool isExportIntervalSelectable;
  final bool isExportable;

  const ExportState(
    this.isExportTargetSelectable,
    this.isExportIntervalSelectable,
    this.isExportable,
  );

  @override
  List<Object> get props => [
        ...super.props,
        isExportTargetSelectable,
        isExportIntervalSelectable,
      ];
}

class InitialExportState extends ExportState {
  const InitialExportState() : super(true, false, false);
}

class ExportTargetConfigurationExportState extends ExportState {
  final ExportTarget exportTarget;

  const ExportTargetConfigurationExportState(this.exportTarget)
      : super(true, true, false);

  @override
  List<Object> get props => [...super.props, exportTarget];
}

class LocationDateTimeIntervalConfigurationExportState extends ExportState {
  final ExportTarget exportTarget;
  final LocationDateTimeInterval exportInterval;

  const LocationDateTimeIntervalConfigurationExportState(
    this.exportTarget,
    this.exportInterval,
  ) : super(true, true, true);

  @override
  List<Object> get props => [...super.props, exportTarget, exportInterval];
}

class ExportingState extends ExportState {
  final ExportConfiguration configuration;

  const ExportingState(this.configuration) : super(false, false, false);

  @override
  List<Object> get props => [...super.props, configuration];
}

class ExportingErrorState extends ExportState implements CubitErrorState {
  @override
  final ExportLocationException error;

  const ExportingErrorState(this.error) : super(false, false, false);

  @override
  List<Object> get props => [...super.props, error];
}

class ExportedState extends ExportState {
  final ExportConfiguration configuration;

  const ExportedState(this.configuration) : super(true, true, true);

  @override
  List<Object> get props => [...super.props, configuration];
}
