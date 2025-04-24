import 'package:dio/dio.dart';
import 'package:drones_dashboard/core/constant/endpointes.dart';
import '../../core/constant/string.dart';
import '../../shared/utils/errors.dart';
import '../models/telemetry_model.dart';
import '../models/drone_model.dart';
import '../models/predection_model.dart';
import '../models/path_model.dart';

/// [ApiClient] is a class that handles all direct API communication
/// It uses the DioHelper class for HTTP requests
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  /// Initialize API client with base configuration
  static ApiClient init() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        receiveDataWhenStatusError: true,
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    return ApiClient(dio);
  }

  /// Fetch drone data from the server
  /// Returns a list of drone models
  Future<List<DroneModel>> getDrones({String? token}) async {
    try {
      final response = await _dio.get(
        '${AppConstants.droneEndpoint}',
        options: Options(
          headers: {
            'Authorization': token != null ? "Bearer $token" : '',
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final List droneList = response.data['data'] ?? [];
        return droneList.map((drone) => DroneModel.fromJson(drone)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get drones',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Fetch telemetry data for a specific drone
  Future<TelemetryModel> getTelemetry(String droneId, {String? token}) async {
    try {
      final response = await _dio.get(
        '${AppConstants.telemetryEndpoint}/$droneId',
        options: Options(
          headers: {
            'Authorization': token != null ? "Bearer $token" : '',
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return TelemetryModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get telemetry',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Start a simulation with a specific configuration
  Future<bool> startSimulation(Map<String, dynamic> config, {String? token}) async {
    try {
      final response = await _dio.post(
        '${AppConstants.simulationEndpoint}/start',
        data: config,
        options: Options(
          headers: {
            'Authorization': token != null ? "Bearer $token" : '',
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to start simulation',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Stop an ongoing simulation
  Future<bool> stopSimulation({String? token}) async {
    try {
      final response = await _dio.post(
        '${AppConstants.simulationEndpoint}/stop',
        options: Options(
          headers: {
            'Authorization': token != null ? "Bearer $token" : '',
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to stop simulation',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Get predictions from a specific ML model
  Future<List<PredictionModel>> getPredictions(
    String droneId, 
    String modelType, 
    Map<String, dynamic> params, 
    {String? token}
  ) async {
    try {
      final response = await _dio.post(
        '${AppConstants.predictionEndpoint}/$droneId/$modelType',
        data: params,
        options: Options(
          headers: {
            'Authorization': token != null ? "Bearer $token" : '',
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final List predictionList = response.data['data'] ?? [];
        return predictionList
            .map((prediction) => PredictionModel.fromJson(prediction))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get predictions',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Save a path for a drone
  Future<PathModel> setPath(String droneId, PathModel path, {String? token}) async {
    try {
      final response = await _dio.post(
        '${AppConstants.pathEndpoint}/$droneId',
        data: path.toJson(),
        options: Options(
          headers: {
            'Authorization': token != null ? "Bearer $token" : '',
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return PathModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to set path',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
  
  /// Generate an optimized path between points
  Future<PathModel> generatePath(
    String droneId,
    Map<String, dynamic> pathParams,
    {String? token}
  ) async {
    try {
      final response = await _dio.post(
        '${AppConstants.pathGenerationEndpoint}/$droneId',
        data: pathParams,
        options: Options(
          headers: {
            'Authorization': token != null ? "Bearer $token" : '',
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return PathModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to generate path',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}