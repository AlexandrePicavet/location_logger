import 'package:flutter/material.dart';
import 'package:location_logger/common/adapter/ui/widget/cubit/state_widget.dart';
import 'package:location_logger/common/adapter/ui/widget/loaders/circular_loader.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';

class LoadingLocationList extends StateWidget<LocationCubit, LocationLoading> {
  const LoadingLocationList({
    super.key,
    required super.cubit,
    required super.state,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularLoader(
      annotation: Text("Loading location data"),
    );
  }
}
