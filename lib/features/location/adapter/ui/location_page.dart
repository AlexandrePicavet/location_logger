import 'package:flutter/material.dart';
import 'package:location_logger/common/model/service_locator.dart';
import 'package:location_logger/features/location/application/usecase/locations_list_usecase.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pagination = DateTimePagination.before(end: DateTime.now());
    final task = serviceLocator<LocationsListUsecase>().list(pagination).run();
    return FutureBuilder(
      future: task,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          if (data.isRight()) {
            final paginatedList = snapshot.data!.getRight().toNullable()!;
            if (paginatedList.list.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final item = paginatedList.list[index];
                  return ListTile(
                    key: Key(item.dateTime.millisecondsSinceEpoch.toString()),
                    title: Text("${item.latitude} / ${item.longitude}"),
                  );
                },
                itemCount: paginatedList.list.length,
              );
            } else {
              return const Text("No location");
            }
          } else {
            return Text("Error: ${data.getLeft().toNullable()?.cause}");
          }
        } else {
          return const Text("No data");
        }
      },
    );
  }
}
