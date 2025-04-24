import 'package:drones_dashboard/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Import your bloc files
import '../../core/constant/images.dart';
import '../../core/constant/string.dart';
import '../../core/theme/theme.dart';
import '../bloc/map/map_bloc.dart';
import '../bloc/ml_output/ml_bloc.dart';
import '../bloc/simulation/simulation_bloc.dart';
import '../bloc/telemetry/telemetry_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MapController _mapController = MapController();
  final _formKey = GlobalKey<FormState>();
  String _selectedModel = AppConstants.modelKNN;
  bool _isOutputPanelExpanded = true;

  // Controllers for model parameters
  late TextEditingController _kValueController;
  late TextEditingController _distanceMetricController;
  late TextEditingController _learningRateController;
  late TextEditingController _regularizationController;
  late TextEditingController _kernelController;
  late TextEditingController _cParameterController;
  late TextEditingController _hiddenUnitsController;
  late TextEditingController _sequenceLengthController;
  late TextEditingController _dropoutRateController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _kValueController = TextEditingController();
    _distanceMetricController = TextEditingController();
    _learningRateController = TextEditingController();
    _regularizationController = TextEditingController();
    _kernelController = TextEditingController();
    _cParameterController = TextEditingController();
    _hiddenUnitsController = TextEditingController();
    _sequenceLengthController = TextEditingController();
    _dropoutRateController = TextEditingController();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _kValueController.dispose();
    _distanceMetricController.dispose();
    _learningRateController.dispose();
    _regularizationController.dispose();
    _kernelController.dispose();
    _cParameterController.dispose();
    _hiddenUnitsController.dispose();
    _sequenceLengthController.dispose();
    _dropoutRateController.dispose();
  }

  void _clearAllControllers() {
    _kValueController.clear();
    _distanceMetricController.clear();
    _learningRateController.clear();
    _regularizationController.clear();
    _kernelController.clear();
    _cParameterController.clear();
    _hiddenUnitsController.clear();
    _sequenceLengthController.clear();
    _dropoutRateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SidebarWidget(),
          Expanded(
            child: Column(
              children: [
                const TopBarWidget(),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: BlocBuilder<MapBloc, MapState>(
                          builder: (context, state) {
                            if (state is MapReady) {
                              return _buildMap(state);
                            } else if (state is MapError) {
                              return Center(child: Text(state.message));
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          margin: const EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ML Model Selection',
                                ),
                                const SizedBox(height: 16),
                                _buildModelDropdown(),
                                const SizedBox(height: 24),
                                Text(
                                  'Model Parameters',
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: _buildParametersForm(),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _runModel,
                                    child: const Text('RUN MODEL'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isOutputPanelExpanded
                      ? context.height * 0.3
                      : kToolbarHeight,
                  child: Container(
                    color: AppTheme.backgroundTaskBar,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Model Output',
                            ),
                            IconButton(
                              icon: Icon(_isOutputPanelExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more),
                              onPressed: () => setState(() {
                                _isOutputPanelExpanded =
                                    !_isOutputPanelExpanded;
                              }),
                            ),
                          ],
                        ),
                        if (_isOutputPanelExpanded) ...[
                          const SizedBox(height: 8),
                          const Divider(),
                          Expanded(
                            child: BlocBuilder<MlOutputBloc, MlOutputState>(
                              builder: (context, state) {
                                if (state is MlOutputLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state is MlOutputLoaded) {
                                  return _buildModelOutput(state);
                                } else if (state is MlOutputError) {
                                  return Center(
                                    child: Text(
                                      'Error: ${state.message}',
                                      style: const TextStyle(
                                          color: Colors.redAccent),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: Text('Run a model to see output'),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(MapReady state) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: state.center,
            initialZoom: state.zoom,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                context.read<MapBloc>().add(MapCenterChanged(position.center!));
                context.read<MapBloc>().add(MapZoomChanged(position.zoom!));
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: state.mapType == 'satellite'
                  ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                  : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            BlocBuilder<TelemetryBloc, TelemetryState>(
              builder: (context, telemetryState) {
                if (telemetryState is TelemetryLoaded) {
                  return MarkerLayer(
                    markers: telemetryState.drones
                        .where((drone) =>
                            telemetryState.latestTelemetry[drone.id] != null)
                        .map((drone) {
                      final telemetry =
                          telemetryState.latestTelemetry[drone.id]!;
                      return Marker(
                        width: 60,
                        height: 60,
                        point: LatLng(telemetry.latitude, telemetry.longitude),
                        child: GestureDetector(
                          onTap: () => _showDroneDetails(drone.id),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.backgroundDark,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppTheme.mediumG),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      Images.drone_on,
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Drone ${drone.id}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return const MarkerLayer(markers: []);
              },
            ),
            BlocBuilder<TelemetryBloc, TelemetryState>(
              builder: (context, telemetryState) {
                if (telemetryState is TelemetryLoaded) {
                  return CircleLayer(
                    circles: telemetryState.drones
                        .where((drone) =>
                            telemetryState.latestTelemetry[drone.id] != null)
                        .map((drone) {
                      final telemetry =
                          telemetryState.latestTelemetry[drone.id]!;
                      return CircleMarker(
                        point: LatLng(telemetry.latitude, telemetry.longitude),
                        radius: AppConstants.defaultSignalRadius,
                        color: AppTheme.lightG.withOpacity(0.2),
                        borderColor: AppTheme.mediumG,
                        borderStrokeWidth: 2,
                      );
                    }).toList(),
                  );
                }
                return const CircleLayer<Object>(
                  circles: [],
                );
              },
            ),
          ],
        ),
        _buildMapControls(state),
      ],
    );
  }

  Widget _buildModelDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedModel,
      decoration: const InputDecoration(
        labelText: 'Select ML Model',
        border: OutlineInputBorder(),
      ),
      items: AppConstants.modelNames.entries.map((entry) {
        return DropdownMenuItem(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedModel = value;
            _clearAllControllers();
          });
          context.read<MlOutputBloc>().add(SelectModelEvent(value));
        }
      },
    );
  }

  Widget _buildParametersForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildParameterFields(),
        ),
      ),
    );
  }

  List<Widget> _buildParameterFields() {
    switch (_selectedModel) {
      case AppConstants.modelKNN:
        return [
          TextFormField(
            controller: _kValueController,
            decoration: const InputDecoration(
              labelText: 'K Value',
              hintText: 'Enter number of neighbors',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _distanceMetricController,
            decoration: const InputDecoration(
              labelText: 'Distance Metric',
              hintText: 'e.g., euclidean',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
        ];
      case AppConstants.modelLR:
        return [
          TextFormField(
            controller: _learningRateController,
            decoration: const InputDecoration(
              labelText: 'Learning Rate',
              hintText: 'e.g., 0.01',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _regularizationController,
            decoration: const InputDecoration(
              labelText: 'Regularization',
              hintText: 'e.g., 0.001',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
        ];
      case AppConstants.modelSVM:
        return [
          TextFormField(
            controller: _kernelController,
            decoration: const InputDecoration(
              labelText: 'Kernel',
              hintText: 'e.g., rbf',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _cParameterController,
            decoration: const InputDecoration(
              labelText: 'C Parameter',
              hintText: 'e.g., 1.0',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
        ];
      case AppConstants.modelLSTM:
        return [
          TextFormField(
            controller: _hiddenUnitsController,
            decoration: const InputDecoration(
              labelText: 'Hidden Units',
              hintText: 'e.g., 128',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _sequenceLengthController,
            decoration: const InputDecoration(
              labelText: 'Sequence Length',
              hintText: 'e.g., 10',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _dropoutRateController,
            decoration: const InputDecoration(
              labelText: 'Dropout Rate',
              hintText: 'e.g., 0.2',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Required field' : null,
          ),
        ];
      default:
        return [const Text('Select a model to see parameters')];
    }
  }

  void _runModel() {
    if (!_formKey.currentState!.validate()) return;

    final telemetryState = context.read<TelemetryBloc>().state;
    if (telemetryState is! TelemetryLoaded || telemetryState.drones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active drone found')),
      );
      return;
    }

    final inputData = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
    };

    switch (_selectedModel) {
      case AppConstants.modelKNN:
        inputData.addAll({
          'k': int.parse(_kValueController.text),
          'distance_metric': _distanceMetricController.text,
        });
        break;
      case AppConstants.modelLR:
        inputData.addAll({
          'learning_rate': double.parse(_learningRateController.text),
          'regularization': double.parse(_regularizationController.text),
        });
        break;
      case AppConstants.modelSVM:
        inputData.addAll({
          'kernel': _kernelController.text,
          'c_parameter': double.parse(_cParameterController.text),
        });
        break;
      case AppConstants.modelLSTM:
        inputData.addAll({
          'hidden_units': int.parse(_hiddenUnitsController.text),
          'sequence_length': int.parse(_sequenceLengthController.text),
          'dropout_rate': double.parse(_dropoutRateController.text),
        });
        break;
    }

    context.read<MlOutputBloc>().add(GetPredictionEvent(
          modelType: _selectedModel,
          inputData: inputData,
          droneId: telemetryState.drones.first.id,
        ));
  }

  Widget _buildModelOutput(MlOutputLoaded state) {
    return ListView(
      children: [
        Text('Model: ${AppConstants.modelNames[state.modelType]}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildOutputCard(
          title: 'Prediction',
          items: {
            'Type': state.prediction.type,
            'Confidence':
                '${(state.prediction.confidence * 100).toStringAsFixed(1)}%',
            'Timestamp': state.prediction.timestamp.toString(),
          },
        ),
        if (state.metrics != null) ...[
          const SizedBox(height: 16),
          _buildOutputCard(
            title: 'Metrics',
            items: state.metrics!.map((k, v) => MapEntry(k, v.toString())),
          ),
        ],
      ],
    );
  }

  Widget _buildOutputCard(
      {required String title, required Map<String, String> items}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ...items.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text('${e.key}: ',
                          style:
                              const TextStyle(color: AppTheme.textSecondary)),
                      Expanded(child: Text(e.value)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControls(MapReady state) {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: () => _adjustZoom(1),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () => _adjustZoom(-1),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'map_type',
            onPressed: () => context.read<MapBloc>().add(MapTypeChanged(
                state.mapType == 'standard' ? 'satellite' : 'standard')),
            child: const Icon(Icons.layers),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'show_all',
            onPressed: () =>
                context.read<MapBloc>().add(ShowAllDronesRequested()),
            child: const Icon(Icons.fit_screen),
          ),
        ],
      ),
    );
  }

  void _adjustZoom(int delta) {
    // final newZoom = _mapController.zoom + delta;
    // _mapController.move(_mapController.center, newZoom);
    // context.read<MapBloc>().add(MapZoomChanged(newZoom));
  }

  void _showDroneDetails(String droneId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Drone $droneId Details'),
        content: BlocBuilder<TelemetryBloc, TelemetryState>(
          builder: (context, state) {
            if (state is TelemetryLoaded) {
              final telemetry = state.latestTelemetry[droneId];
              return telemetry != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Latitude: ${telemetry.latitude.toStringAsFixed(6)}'),
                        Text(
                            'Longitude: ${telemetry.longitude.toStringAsFixed(6)}'),
                        Text('Altitude: ${telemetry.altitude}m'),
                        Text('Battery: ${telemetry.batteryLevel}%'),
                      ],
                    )
                  : const Text('No telemetry data available');
            }
            return const CircularProgressIndicator();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: AppTheme.backgroundTaskBar,
      child: Column(
        children: [
          // Logo
          Container(
            height: 60,
            alignment: Alignment.center,
            color: AppTheme.backgroundDark,
            child: SvgPicture.asset(
              Images.xctrl,
              height: 30,
            ),
          ),

          // User Avatar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.mediumG,
                  radius: 25,
                  child: SvgPicture.asset(
                    Images.drone_on,
                    height: 24,
                    width: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'unknown-34',
                  style: TextStyle(fontSize: 12),
                ),
                const Text(
                  'ADMINISTRATOR',
                  style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Navigation Items
          _buildNavItem(context, 'Home', Icons.home, true),
          _buildNavItem(context, 'Map', Icons.map, false),
          _buildNavItem(context, 'Live View', Icons.videocam, false),

          const Spacer(),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: AppTheme.textSecondary),
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String label, IconData icon, bool isActive) {
    return InkWell(
      onTap: () {
        // Navigation logic
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: isActive
              ? Border(
                  left: BorderSide(
                    color: AppTheme.mediumG,
                    width: 3,
                  ),
                )
              : null,
          color: isActive ? AppTheme.backgroundTaskBar.withOpacity(0.5) : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.mediumG : AppTheme.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? AppTheme.mediumG : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Top Bar Widget
class TopBarWidget extends StatelessWidget {
  const TopBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundTaskBar,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.strokeGrey,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'DRONE CONTROL DASHBOARD',
          ),
          const Spacer(),
          IconButton(
            icon: SvgPicture.asset(
              Images.bell,
              height: 24,
              width: 24,
              color: AppTheme.textSecondary,
            ),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Start simulation
              context.read<SimulationBloc>().add(
                    StartSimulationEvent(
                      modelType: 'default',
                      parameters: {},
                    ),
                  );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('START SIMULATION'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkerG,
            ),
          ),
        ],
      ),
    );
  }
}
