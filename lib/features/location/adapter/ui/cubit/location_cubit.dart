import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location_logger/common/model/service_locator.dart';
import 'package:location_logger/features/location/application/port/location_retrieval_port.dart';
import 'package:location_logger/features/location/application/port/model/exception/location_retrieval_exception.dart';
import 'package:location_logger/features/location/domain/date_time_paginated_list.dart';
import 'package:location_logger/features/location/domain/date_time_pagination.dart';
import 'package:location_logger/features/location/domain/location.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRetrievalPort locationRetrievalPort;

  LocationCubit()
      : locationRetrievalPort = serviceLocator(),
        super(const LocationInitial());

  void reset() {
    emit(const LocationInitial());
  }

  void listLocations(DateTimePagination pagination) async {
    emit(const LocationLoading());

    await locationRetrievalPort
        .list(pagination)
        .bimap(LocationListError.new, LocationLoaded.new)
        .match(emit, emit)
        .run();
  }
}
