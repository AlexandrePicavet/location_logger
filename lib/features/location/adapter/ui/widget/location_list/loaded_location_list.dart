import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_logger/common/adapter/ui/widget/cubit/state_widget.dart';
import 'package:location_logger/common/adapter/ui/widget/location_date_range_picker.dart';
import 'package:location_logger/features/location/adapter/ui/cubit/location_cubit.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';

class LoadedLocationList extends StateWidget<LocationCubit, LocationLoaded> {
  const LoadedLocationList({
    super.key,
    required super.cubit,
    required super.state,
  });

  @override
  Widget build(BuildContext context) {
    final pagination = state.locations.pagination;
    final locations = state.locations.list;

    return Column(
      children: [
        LocationDateRangePicker(
          onSelect: retrieve,
          start: pagination.start,
          end: pagination.end,
        ),
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
        ElevatedButton(
          onPressed: cubit.reset,
          child: const Text("Refresh"),
        ),
      ],
    );
  }

  void retrieve(Option<DateTimeRange> rangeOption) {
    rangeOption.fold(
      () => {},
      (range) => cubit.listLocations(
        DateTimePagination.between(
          start: range.start,
          end: range.end,
        ),
      ),
    );
  }
}
