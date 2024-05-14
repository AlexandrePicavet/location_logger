import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_logger/common/widget/screen.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';
import 'package:location_logger/features/location/adapter/ui/widget/location_list.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationCubit>(
      create: (_) => LocationCubit(),
      child: const Screen(child: LocationList()),
    );
  }
}
