import 'package:get_it/get_it.dart';


/// This is a singleton class that will be used to register all the dependencies
/// in the app.
/// [locator] is the instance of the [GetIt] class.
/// 
/// [setup] is the method that will be called in the main function to register
/// all the dependencies.
///
/// example:
/// ```dart
///
/// final user = DepInj.locator<AuthBloc>().user;
/// ```
class DepInj {
  static final locator = GetIt.instance;
}
