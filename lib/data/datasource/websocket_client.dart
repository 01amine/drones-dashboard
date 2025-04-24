import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  final String _url;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  final StreamController<Map<String, dynamic>> _messageController = StreamController.broadcast();
  
  WebSocketClient({
    String url = '',
  }) : _url = url;
  
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isConnected => _isConnected;
  
  Future<void> connect() async {
    if (_isConnected) return;
    
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));
      _isConnected = true;
      
      _channel!.stream.listen(
        (dynamic message) {
          try {
            final Map<String, dynamic> data = jsonDecode(message);
            _messageController.add(data);
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        },
        onDone: _handleDisconnect,
        onError: (error) {
          print('WebSocket error: $error');
          _handleDisconnect();
        },
      );
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      _handleDisconnect();
    }
  }
  
  void _handleDisconnect() {
    _isConnected = false;
    _channel = null;
    
    // Set up reconnection timer
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      Duration(seconds: 10),
      connect,
    );
  }
  
  void send(Map<String, dynamic> data) {
    if (!_isConnected || _channel == null) {
      print('Cannot send message: WebSocket not connected');
      return;
    }
    
    try {
      _channel!.sink.add(jsonEncode(data));
    } catch (e) {
      print('Error sending WebSocket message: $e');
    }
  }
  
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    
    if (_channel != null) {
      await _channel!.sink.close();
      _isConnected = false;
      _channel = null;
    }
  }
  
  // For simulation, generate a stream of mock telemetry updates
  Stream<Map<String, dynamic>> simulateTelemetryUpdates() async* {
    final random = Random();
    
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      
      yield {
        'type': 'telemetry',
        'droneId': '7.78.2',
        'latitude': 31.5051 + (random.nextDouble() - 0.5) * 0.001,
        'longitude': -97.2029 + (random.nextDouble() - 0.5) * 0.001,
        'altitude': 100 + random.nextInt(50),
        'batteryLevel': max(0, 95 - random.nextInt(30)),
        'speed': 5 + random.nextInt(10),
        'heading': random.nextInt(360),
      };
    }
  }
}