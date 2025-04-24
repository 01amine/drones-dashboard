import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server failure occurred']): super(message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([String message = 'Connection failure occurred']): super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache failure occurred']): super(message);
}

class PredictionFailure extends Failure {
  const PredictionFailure([String message = 'Failed to generate prediction']): super(message);
}

class ModelNotFoundFailure extends Failure {
  const ModelNotFoundFailure([String message = 'ML model not found']): super(message);
}