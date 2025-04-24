import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drones_dashboard/core/theme/theme.dart';

// Use case imports
import 'package:drones_dashboard/domain/usecases/start_simulation.dart';
import 'package:drones_dashboard/domain/usecases/stop_simulation.dart';

import 'data/repositories/path_repository_impl.dart';
import 'data/repositories/simulation_repository_impl.dart';
import 'data/repositories/telemetry_repository_impl.dart';
import 'presentation/bloc/map/map_bloc.dart';
import 'presentation/bloc/ml_output/ml_bloc.dart';
import 'presentation/bloc/simulation/simulation_bloc.dart';
import 'presentation/bloc/telemetry/telemetry_bloc.dart';
import 'presentation/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final simulationRepository = SimulationRepositoryImpl();
    final telemetryRepository = TelemetryRepositoryImpl();
    final predictionRepository = PredictionRepositoryImpl();

    // Initialize use cases
    final startSimulation = StartSimulation(simulationRepository);
    final stopSimulation = StopSimulation(simulationRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(
          create: (context) => MapBloc()..add(MapInitialized()),
        ),
        BlocProvider<TelemetryBloc>(
          create: (context) => TelemetryBloc(
            telemetryRepository: telemetryRepository,
          )..add(FetchTelemetryData()),
        ),
        BlocProvider<MlOutputBloc>(
          create: (context) => MlOutputBloc(
            predictionRepository: predictionRepository,
          )..add(LoadAvailableModelsEvent()),
        ),
        BlocProvider<SimulationBloc>(
          create: (context) => SimulationBloc(
            startSimulation: startSimulation,
            stopSimulation: stopSimulation,
            simulationRepository: simulationRepository,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Drone Dashboard',
        theme: AppTheme.darkTheme(),
        themeMode: ThemeMode.dark,
        home: const DashboardScreen(),
        builder: (context, child) {
          return BlocListener<TelemetryBloc, TelemetryState>(
            listener: (context, state) {
              if (state is TelemetryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: child!,
          );
        },
      ),
    );
  }
}
