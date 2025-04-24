// presentation/bloc/map/map_event.dart
import 'package:drones_dashboard/core/constant/string.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class MapEvent extends Equatable {
  const MapEvent();
  
  @override
  List<Object?> get props => [];
}

class MapInitialized extends MapEvent {}

class MapTypeChanged extends MapEvent {
  final String mapType; // 'standard', 'satellite', 'hybrid', etc.
  
  const MapTypeChanged(this.mapType);
  
  @override
  List<Object?> get props => [mapType];
}

class MapCenterChanged extends MapEvent {
  final LatLng center;
  
  const MapCenterChanged(this.center);
  
  @override
  List<Object?> get props => [center];
}

class MapZoomChanged extends MapEvent {
  final double zoom;
  
  const MapZoomChanged(this.zoom);
  
  @override
  List<Object?> get props => [zoom];
}

class FollowDroneToggled extends MapEvent {
  final String? droneId; // null means don't follow any drone
  
  const FollowDroneToggled(this.droneId);
  
  @override
  List<Object?> get props => [droneId];
}

class ShowAllDronesRequested extends MapEvent {}

// presentation/bloc/map/map_state.dart


abstract class MapState extends Equatable {
  const MapState();
  
  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapReady extends MapState {
  final String mapType;
  final LatLng center;
  final double zoom;
  final String? followingDroneId;
  
  const MapReady({
    required this.mapType,
    required this.center,
    required this.zoom,
    this.followingDroneId,
  });
  
  @override
  List<Object?> get props => [mapType, center, zoom, followingDroneId];
  
  MapReady copyWith({
    String? mapType,
    LatLng? center,
    double? zoom,
    String? followingDroneId,
    bool clearFollowingDrone = false,
  }) {
    return MapReady(
      mapType: mapType ?? this.mapType,
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      followingDroneId: clearFollowingDrone ? null : (followingDroneId ?? this.followingDroneId),
    );
  }
}

class MapError extends MapState {
  final String message;
  
  const MapError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// presentation/bloc/map/map_bloc.dart


class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<MapInitialized>(_onMapInitialized);
    on<MapTypeChanged>(_onMapTypeChanged);
    on<MapCenterChanged>(_onMapCenterChanged);
    on<MapZoomChanged>(_onMapZoomChanged);
    on<FollowDroneToggled>(_onFollowDroneToggled);
    on<ShowAllDronesRequested>(_onShowAllDronesRequested);
  }

  void _onMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) {
    emit(MapReady(
      mapType: AppConstants.defaultMapType,
      center: AppConstants.defaultCenter,
      zoom: AppConstants.defaultZoom,
    ));
  }

  void _onMapTypeChanged(
    MapTypeChanged event,
    Emitter<MapState> emit,
  ) {
    if (state is MapReady) {
      emit((state as MapReady).copyWith(mapType: event.mapType));
    }
  }

  void _onMapCenterChanged(
    MapCenterChanged event,
    Emitter<MapState> emit,
  ) {
    if (state is MapReady) {
      final currentState = state as MapReady;
      // Only update center if not following a drone
      if (currentState.followingDroneId == null) {
        emit(currentState.copyWith(center: event.center));
      }
    }
  }

  void _onMapZoomChanged(
    MapZoomChanged event,
    Emitter<MapState> emit,
  ) {
    if (state is MapReady) {
      emit((state as MapReady).copyWith(zoom: event.zoom));
    }
  }

  void _onFollowDroneToggled(
    FollowDroneToggled event,
    Emitter<MapState> emit,
  ) {
    if (state is MapReady) {
      if (event.droneId == null) {
        emit((state as MapReady).copyWith(clearFollowingDrone: true));
      } else {
        emit((state as MapReady).copyWith(followingDroneId: event.droneId));
      }
    }
  }

  void _onShowAllDronesRequested(
    ShowAllDronesRequested event,
    Emitter<MapState> emit,
  ) {
    if (state is MapReady) {
      // This would typically calculate a bounding box for all drones
      // Here we just reset to default view and stop following any drone
      emit((state as MapReady).copyWith(
        center: AppConstants.defaultCenter,
        zoom: AppConstants.defaultZoom,
        clearFollowingDrone: true,
      ));
    }
  }
}
