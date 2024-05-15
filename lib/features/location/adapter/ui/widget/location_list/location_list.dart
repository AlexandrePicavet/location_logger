import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';
import 'package:location_logger/features/location/adapter/ui/widget/location_list/error_location_list.dart';
import 'package:location_logger/features/location/adapter/ui/widget/location_list/initial_location_list.dart';
import 'package:location_logger/features/location/adapter/ui/widget/location_list/loaded_location_list.dart';
import 'package:location_logger/features/location/adapter/ui/widget/location_list/loading_location_list.dart';

class LocationList extends StatelessWidget {
  const LocationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) => switch (state) {
        LocationInitial() => InitialLocationList(
            cubit: context.read<LocationCubit>(),
            state: state,
          ),
        LocationLoading() => LoadingLocationList(
            cubit: context.read<LocationCubit>(),
            state: state,
          ),
        LocationListError() => ErrorLocationList(
            cubit: context.read<LocationCubit>(),
            state: state,
          ),
        LocationLoaded() => LoadedLocationList(
            cubit: context.read<LocationCubit>(),
            state: state,
          ),
        _ => throw Exception(
            "Visual not implemented for LocationState: '${state.runtimeType}'",
          ),
      },
    );
  }
}
