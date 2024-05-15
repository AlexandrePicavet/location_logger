import 'package:flutter/material.dart';
import 'package:location_logger/common/adapter/ui/widget/cubit/error_state_visualizer.dart';
import 'package:location_logger/common/adapter/ui/widget/cubit/state_widget.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';

class ErrorLocationList extends StateWidget<LocationCubit, LocationListError> {
  const ErrorLocationList({
    super.key,
    required super.cubit,
    required super.state,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateVisualizer(
      state: state,
      retry: cubit.reset,
    );
  }
}
