import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_logger/common/adapter/ui/widget/screen.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';
import 'package:location_logger/features/location/adapter/ui/widget/location_list/location_list.dart';
import 'package:location_logger/router.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationCubit(),
      child: Screen(
        child: Column(
          children: [
            const Expanded(child: LocationList()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => context.pushNamed(Routes.export.name),
                  child: const Text("Export"),
                ),
                ElevatedButton(
                  onPressed: () => context.pushNamed(Routes.import.name),
                  child: const Text("Import"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
