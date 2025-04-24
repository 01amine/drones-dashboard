// presentation/bloc/telemetry/telemetry_event.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/drone.dart';
import '../../../domain/entities/telemetry.dart';import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/telemtry_repository.dart';
abstract class TelemetryEvent extends Equatable {
  const TelemetryEvent();
  
  @override
  List<Object?> get props => [];
}

class FetchTelemetryData extends TelemetryEvent {}

class DroneDataUpdated extends TelemetryEvent {
  final List<Drone> drones;
  
  const DroneDataUpdated(this.drones);
  
  @override
  List<Object?> get props => [drones];
}

class TelemetryDataUpdated extends TelemetryEvent {
  final Telemetry telemetry;
  
  const TelemetryDataUpdated(this.telemetry);
  
  @override
  List<Object?> get props => [telemetry];
}

class SendDroneCommand extends TelemetryEvent {
  final String droneId;
  final String command;
  final Map<String, dynamic> parameters;
  
  const SendDroneCommand({
    required this.droneId,
    required this.command,
    required this.parameters,
  });
  
  @override
  List<Object?> get props => [droneId, command, parameters];
}

// presentation/bloc/telemetry/telemetry_state.dart


abstract class TelemetryState extends Equatable {
  const TelemetryState();
  
  @override
  List<Object?> get props => [];
}

class TelemetryInitial extends TelemetryState {}

class TelemetryLoading extends TelemetryState {}

class TelemetryLoaded extends TelemetryState {
  final List<Drone> drones;
  final Map<String, Telemetry> latestTelemetry;
  
  const TelemetryLoaded({
    required this.drones,
    this.latestTelemetry = const {},
  });
  
  @override
  List<Object?> get props => [drones, latestTelemetry];
  
  TelemetryLoaded copyWith({
    List<Drone>? drones,
    Map<String, Telemetry>? latestTelemetry,
  }) {
    return TelemetryLoaded(
      drones: drones ?? this.drones,
      latestTelemetry: latestTelemetry ?? this.latestTelemetry,
    );
  }
}

class TelemetryError extends TelemetryState {
  final String message;
  
  const TelemetryError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class CommandSending extends TelemetryState {}

class CommandSent extends TelemetryState {}

class CommandError extends TelemetryState {
  final String message;
  
  const CommandError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// presentation/bloc/telemetry/telemetry_bloc.dart


class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  final TelemetryRepository _telemetryRepository;
  late StreamSubscription<List<Drone>> _dronesSubscription;
  Map<String, StreamSubscription<dynamic>> _telemetrySubscriptions = {};

  TelemetryBloc({
    required TelemetryRepository telemetryRepository,
  }) : _telemetryRepository = telemetryRepository,
       super(TelemetryInitial()) {
    on<FetchTelemetryData>(_onFetchTelemetryData);
    on<DroneDataUpdated>(_onDroneDataUpdated);
    on<TelemetryDataUpdated>(_onTelemetryDataUpdated);
    on<SendDroneCommand>(_onSendDroneCommand);
  }

  Future<void> _onFetchTelemetryData(
    FetchTelemetryData event,
    Emitter<TelemetryState> emit,
  ) async {
    emit(TelemetryLoading());
    try {
      // Start listening to drone updates
      _dronesSubscription = _telemetryRepository.getDrones().listen(
        (drones) => add(DroneDataUpdated(drones)),
        onError: (error) => emit(TelemetryError(error.toString())),
      );
    } catch (e) {
      emit(TelemetryError(e.toString()));
    }
  }

  void _onDroneDataUpdated(
    DroneDataUpdated event,
    Emitter<TelemetryState> emit,
  ) {
    // Update telemetry subscriptions for all drones
    _updateTelemetrySubscriptions(event.drones);
    
    if (state is TelemetryLoaded) {
      emit((state as TelemetryLoaded).copyWith(drones: event.drones));
    } else {
      emit(TelemetryLoaded(drones: event.drones));
    }
  }

  void _onTelemetryDataUpdated(
    TelemetryDataUpdated event,
    Emitter<TelemetryState> emit,
  ) {
    if (state is TelemetryLoaded) {
      final currentState = state as TelemetryLoaded;
      final updatedTelemetry = Map<String, Telemetry>.from(currentState.latestTelemetry);
      updatedTelemetry[event.telemetry.droneId] = event.telemetry;
      
      emit(currentState.copyWith(latestTelemetry: updatedTelemetry));
    }
  }

  Future<void> _onSendDroneCommand(
    SendDroneCommand event,
    Emitter<TelemetryState> emit,
  ) async {
    emit(CommandSending());
    try {
      await _telemetryRepository.sendCommand(
        event.droneId, 
        event.command, 
        event.parameters,
      );
      emit(CommandSent());
      
      // Return to previous state after command
      if (state is TelemetryLoaded) {
        final currentState = state as TelemetryLoaded;
        emit(currentState);
      } else {
        add(FetchTelemetryData());
      }
    } catch (e) {
      emit(CommandError(e.toString()));
    }
  }

  void _updateTelemetrySubscriptions(List<Drone> drones) {
    // Cancel subscriptions for drones that are no longer present
    final droneIds = drones.map((drone) => drone.id).toSet();
    _telemetrySubscriptions.keys
        .where((id) => !droneIds.contains(id))
        .toList()
        .forEach((id) {
          _telemetrySubscriptions[id]?.cancel();
          _telemetrySubscriptions.remove(id);
        });

    // Add subscriptions for new drones
    for (final drone in drones) {
      if (!_telemetrySubscriptions.containsKey(drone.id)) {
        _telemetrySubscriptions[drone.id] = _telemetryRepository
            .getDroneTelemetry(drone.id)
            .listen(
              (telemetry) => add(TelemetryDataUpdated(telemetry)),
              onError: (error) => add(TelemetryError(error.toString()) as TelemetryEvent),
            );
      }
    }
  }

  @override
  Future<void> close() {
    _dronesSubscription.cancel();
    _telemetrySubscriptions.values.forEach((subscription) => subscription.cancel());
    return super.close();
  }
}