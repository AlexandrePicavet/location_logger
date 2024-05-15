part of 'location_cubit.dart';

abstract class LocationState extends CubitState {
  const LocationState();
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationListError extends LocationState implements CubitErrorState {
  @override
  final LocationRetrievalException error;

  const LocationListError(this.error);

  @override
  List<Object> get props => [...super.props, error];
}

class LocationLoaded extends LocationState {
  final DateTimePaginatedList<Location> locations;

  const LocationLoaded(this.locations);

  @override
  List<Object> get props => [...super.props, locations];
}
