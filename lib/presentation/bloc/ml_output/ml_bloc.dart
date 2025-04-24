// ml_output_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/predection.dart';
import '../../../domain/repositories/prediction_repository.dart';

abstract class MlOutputState extends Equatable {
  const MlOutputState();
  
  @override
  List<Object?> get props => [];
}

class MlOutputInitial extends MlOutputState {}

class MlOutputLoading extends MlOutputState {}

class MlOutputError extends MlOutputState {
  final String message;
  
  const MlOutputError(this.message);
  
  @override
  List<Object> get props => [message];
}

class MlOutputLoaded extends MlOutputState {
  final Prediction prediction;
  final String modelType;
  final Map<String, dynamic>? metrics;
  
  const MlOutputLoaded({
    required this.prediction,
    required this.modelType,
    this.metrics,
  });
  
  @override
  List<Object?> get props => [prediction, modelType, metrics];
}

class MlModelsLoaded extends MlOutputState {
  final List<String> availableModels;
  final String? selectedModel;
  
  const MlModelsLoaded({
    required this.availableModels,
    this.selectedModel,
  });
  
  @override
  List<Object?> get props => [availableModels, selectedModel];
}

class MlMetricsLoaded extends MlOutputState {
  final Map<String, dynamic> metrics;
  final String modelType;
  
  const MlMetricsLoaded({
    required this.metrics,
    required this.modelType,
  });
  
  @override
  List<Object> get props => [metrics, modelType];
}

class MlHistoryLoaded extends MlOutputState {
  final List<Prediction> predictions;
  final String droneId;
  
  const MlHistoryLoaded({
    required this.predictions,
    required this.droneId,
  });
  
  @override
  List<Object> get props => [predictions, droneId];
}

// ml_output_event.dart


abstract class MlOutputEvent extends Equatable {
  const MlOutputEvent();
  
  @override
  List<Object?> get props => [];
}

class GetPredictionEvent extends MlOutputEvent {
  final String modelType;
  final Map<String, dynamic> inputData;
  final String droneId;
  
  const GetPredictionEvent({
    required this.modelType,
    required this.inputData,
    required this.droneId,
  });
  
  @override
  List<Object> get props => [modelType, inputData, droneId];
}

class LoadAvailableModelsEvent extends MlOutputEvent {}

class SelectModelEvent extends MlOutputEvent {
  final String modelType;
  
  const SelectModelEvent(this.modelType);
  
  @override
  List<Object> get props => [modelType];
}

class GetModelMetricsEvent extends MlOutputEvent {
  final String modelType;
  
  const GetModelMetricsEvent(this.modelType);
  
  @override
  List<Object> get props => [modelType];
}

class TrainModelEvent extends MlOutputEvent {
  final String modelType;
  final List<Map<String, dynamic>> trainingData;
  
  const TrainModelEvent({
    required this.modelType,
    required this.trainingData,
  });
  
  @override
  List<Object> get props => [modelType, trainingData];
}

class GetPredictionHistoryEvent extends MlOutputEvent {
  final String droneId;
  
  const GetPredictionHistoryEvent(this.droneId);
  
  @override
  List<Object> get props => [droneId];
}

// ml_output_bloc.dart


class MlOutputBloc extends Bloc<MlOutputEvent, MlOutputState> {
  final PredictionRepository predictionRepository;
  
  MlOutputBloc({required this.predictionRepository}) : super(MlOutputInitial()) {
    on<GetPredictionEvent>(_onGetPrediction);
    on<LoadAvailableModelsEvent>(_onLoadAvailableModels);
    on<SelectModelEvent>(_onSelectModel);
    on<GetModelMetricsEvent>(_onGetModelMetrics);
    on<TrainModelEvent>(_onTrainModel);
    on<GetPredictionHistoryEvent>(_onGetPredictionHistory);
  }
  
  Future<void> _onGetPrediction(
    GetPredictionEvent event,
    Emitter<MlOutputState> emit,
  ) async {
    emit(MlOutputLoading());
    
    final result = await predictionRepository.getPrediction(
      event.modelType,
      event.inputData,
    );
    
    result.fold(
      (failure) => emit(MlOutputError(failure!.message)),
      (prediction) => emit(MlOutputLoaded(
        prediction: prediction,
        modelType: event.modelType,
      )),
    );
  }
  
  Future<void> _onLoadAvailableModels(
    LoadAvailableModelsEvent event,
    Emitter<MlOutputState> emit,
  ) async {
    emit(MlOutputLoading());
    
    final result = await predictionRepository.getAvailableModels();
    
    result.fold(
      (failure) => emit(MlOutputError(failure.message)),
      (models) => emit(MlModelsLoaded(availableModels: models)),
    );
  }
  
  Future<void> _onSelectModel(
    SelectModelEvent event,
    Emitter<MlOutputState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is MlModelsLoaded) {
      emit(MlModelsLoaded(
        availableModels: currentState.availableModels,
        selectedModel: event.modelType,
      ));
    } else {
      // First load the available models, then select one
      emit(MlOutputLoading());
      
      final result = await predictionRepository.getAvailableModels();
      
      result.fold(
        (failure) => emit(MlOutputError(failure.message)),
        (models) => emit(MlModelsLoaded(
          availableModels: models,
          selectedModel: event.modelType,
        )),
      );
    }
  }
  
  Future<void> _onGetModelMetrics(
    GetModelMetricsEvent event,
    Emitter<MlOutputState> emit,
  ) async {
    emit(MlOutputLoading());
    
    final result = await predictionRepository.getModelMetrics(event.modelType);
    
    result.fold(
      (failure) => emit(MlOutputError(failure.message)),
      (metrics) => emit(MlMetricsLoaded(
        metrics: metrics,
        modelType: event.modelType,
      )),
    );
  }
  
  Future<void> _onTrainModel(
    TrainModelEvent event,
    Emitter<MlOutputState> emit,
  ) async {
    emit(MlOutputLoading());
    
    final result = await predictionRepository.trainModel(
      event.modelType,
      event.trainingData,
    );
    
    result.fold(
      (failure) => emit(MlOutputError(failure.message)),
      (metrics) => emit(MlMetricsLoaded(
        metrics: metrics,
        modelType: event.modelType,
      )),
    );
  }
  
  Future<void> _onGetPredictionHistory(
    GetPredictionHistoryEvent event,
    Emitter<MlOutputState> emit,
  ) async {
    emit(MlOutputLoading());
    
    final result = await predictionRepository.getPredictionHistory(event.droneId);
    
    result.fold(
      (failure) => emit(MlOutputError(failure.message)),
      (predictions) => emit(MlHistoryLoaded(
        predictions: predictions,
        droneId: event.droneId,
      )),
    );
  }
}