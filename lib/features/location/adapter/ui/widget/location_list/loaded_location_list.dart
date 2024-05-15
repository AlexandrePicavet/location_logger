import 'package:flutter/material.dart';
import 'package:location_logger/common/adapter/ui/widget/cubit/state_widget.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';

class LoadedLocationList extends StateWidget<LocationCubit, LocationLoaded> {
  const LoadedLocationList({
    super.key,
    required super.cubit,
    required super.state,
  });

  @override
  Widget build(BuildContext context) {
    final locations = state.locations.list;

    return Column(
      children: [
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
      ],
    );
  }
}
