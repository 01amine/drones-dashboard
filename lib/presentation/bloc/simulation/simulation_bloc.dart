// presentation/bloc/simulation/simulation_event.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/simulation_repository.dart';
import '../../../domain/usecases/start_simulation.dart';
import '../../../domain/usecases/stop_simulation.dart';
import 'package:equatable/equatable.dart';

abstract class SimulationEvent extends Equatable {
  const SimulationEvent();

  @override
  List<Object?> get props => [];
}

class StartSimulationEvent extends SimulationEvent {
  final String modelType;
  final Map<String, dynamic> parameters;

  const StartSimulationEvent({
    required this.modelType,
    required this.parameters,
  });

  @override
  List<Object?> get props => [modelType, parameters];
}

class PauseSimulationEvent extends SimulationEvent {}

class ResumeSimulationEvent extends SimulationEvent {}

class StopSimulationEvent extends SimulationEvent {}

class SimulationStatusUpdated extends SimulationEvent {
  final bool isRunning;

  const SimulationStatusUpdated(this.isRunning);

  @override
  List<Object?> get props => [isRunning];
}

// presentation/bloc/simulation/simulation_state.dart


abstract class SimulationState extends Equatable {
  const SimulationState();
  
  @override
  List<Object?> get props => [];
}

class SimulationInitial extends SimulationState {}

class SimulationStarting extends SimulationState {}

class SimulationRunning extends SimulationState {}

class SimulationPaused extends SimulationState {}

class SimulationStopped extends SimulationState {}

class SimulationError extends SimulationState {
  final String message;

  const SimulationError(this.message);
  
  @override
  List<Object?> get props => [message];
}


class SimulationBloc extends Bloc<SimulationEvent, SimulationState> {
  final StartSimulation _startSimulation;
  final StopSimulation _stopSimulation;
  final SimulationRepository _simulationRepository;
  late StreamSubscription<bool> _simulationStatusSubscription;

  SimulationBloc({
    required StartSimulation startSimulation,
    required StopSimulation stopSimulation,
    required SimulationRepository simulationRepository,
  }) : _startSimulation = startSimulation,
       _stopSimulation = stopSimulation,
       _simulationRepository = simulationRepository,
       super(SimulationInitial()) {
    on<StartSimulationEvent>(_onStartSimulation);
    on<PauseSimulationEvent>(_onPauseSimulation);
    on<ResumeSimulationEvent>(_onResumeSimulation);
    on<StopSimulationEvent>(_onStopSimulation);
    on<SimulationStatusUpdated>(_onSimulationStatusUpdated);

    _simulationStatusSubscription = _simulationRepository.simulationStatus.listen(
      (isRunning) => add(SimulationStatusUpdated(isRunning)),
    );
  }

  Future<void> _onStartSimulation(
    StartSimulationEvent event,
    Emitter<SimulationState> emit,
  ) async {
    emit(SimulationStarting());
    try {
      await _startSimulation(event.modelType, event.parameters);
      emit(SimulationRunning());
    } catch (e) {
      emit(SimulationError(e.toString()));
    }
  }

  Future<void> _onPauseSimulation(
    PauseSimulationEvent event,
    Emitter<SimulationState> emit,
  ) async {
    try {
      await _simulationRepository.pauseSimulation();
      emit(SimulationPaused());
    } catch (e) {
      emit(SimulationError(e.toString()));
    }
  }

  Future<void> _onResumeSimulation(
    ResumeSimulationEvent event,
    Emitter<SimulationState> emit,
  ) async {
    try {
      await _simulationRepository.resumeSimulation();
      emit(SimulationRunning());
    } catch (e) {
      emit(SimulationError(e.toString()));
    }
  }

  Future<void> _onStopSimulation(
    StopSimulationEvent event,
    Emitter<SimulationState> emit,
  ) async {
    try {
      await _stopSimulation();
      emit(SimulationStopped());
    } catch (e) {
      emit(SimulationError(e.toString()));
    }
  }

  void _onSimulationStatusUpdated(
    SimulationStatusUpdated event,
    Emitter<SimulationState> emit,
  ) {
    if (event.isRunning) {
      emit(SimulationRunning());
    } else {
      emit(SimulationStopped());
    }
  }

  @override
  Future<void> close() {
    _simulationStatusSubscription.cancel();
    return super.close();
  }
}