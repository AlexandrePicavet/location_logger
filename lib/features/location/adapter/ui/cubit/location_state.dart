part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationListError extends LocationState {
  final LocationRetrievalException error;

  const LocationListError(this.error);

  @override
  List<Object> get props => [error];
}

class LocationLoaded extends LocationState {
  final DateTimePaginatedList<Location> locations;

  const LocationLoaded(this.locations);

  @override
  List<Object> get props => [locations];
}
