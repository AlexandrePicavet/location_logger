import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_logger/common/widget/loaders/circular_loader.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';

class LocationList extends StatelessWidget {
  const LocationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) => switch (state) {
        LocationInitial() => initial(context),
        LocationLoading() => const CircularLoader(),
        LocationListError() => error(context, state),
        LocationLoaded() => loaded(context, state),
        _ => throw Exception(
            "Visual not implemented for LocationState: '${state.runtimeType}'",
          ),
      },
    );
  }

  Widget initial(BuildContext context) {
    final cubit = context.read<LocationCubit>();

    cubit.listLocations(
      DateTimePagination.after(start: DateTime.fromMillisecondsSinceEpoch(0)),
    );

    return const CircularLoader();
  }

  Widget error(BuildContext context, LocationListError state) {
    final cubit = context.read<LocationCubit>();
    final causes = state.error.getCauses();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: causes.length,
            itemBuilder: (context, index) {
              final cause = causes[index];
              return ListTile(
                key: Key(cause.toString()),
                title: Text(cause.runtimeType.toString()),
                subtitle: Text(cause.toString()),
                tileColor: Colors.red[300],
              );
            },
          ),
        ),
        TextButton(onPressed: cubit.reset, child: const Text("Retry")),
      ],
    );
  }

  Widget loaded(BuildContext context, LocationLoaded state) {
    final cubit = context.read<LocationCubit>();
    final locations = state.locations.list;

    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];
            return ListTile(
              key: Key(location.toString()),
              title: Text(location.dateTime.toString()),
              subtitle: Text(
                "${location.latitude} / ${location.longitude} ^ ${location.altitude} => ${location.speed}",
              ),
            );
          },
        ),
      ),
      TextButton(onPressed: cubit.reset, child: const Text("Refresh")),
    ]);
  }
}
