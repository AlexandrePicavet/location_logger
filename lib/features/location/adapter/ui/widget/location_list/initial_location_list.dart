import 'package:flutter/material.dart';
import 'package:location_logger/common/adapter/ui/widget/cubit/state_widget.dart';
import 'package:location_logger/common/adapter/ui/widget/loaders/circular_loader.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';

class InitialLocationList extends StateWidget<LocationCubit, LocationInitial> {
  const InitialLocationList({
    super.key,
    required super.cubit,
    required super.state,
  });

  @override
  Widget build(BuildContext context) {
    cubit.listLocations(
      DateTimePagination.after(
        start: DateTime.now().subtract(
          const Duration(days: 1),
        ),
      ),
    );

    return const CircularLoader(
      annotation: Text("Asking for location data"),
    );
  }
}
