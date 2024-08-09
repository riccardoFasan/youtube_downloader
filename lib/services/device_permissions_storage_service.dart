import 'package:shared_preferences/shared_preferences.dart';

class DevicePermissionsStorageService {
  static const String _hasAskedToDisableBatteryOptimizationKey =
      'hasAskedToDisableBatteryOptimization';

  Future<void> storeHasAskedToDisableBatteryOptimization(
      bool hasAskedToDisableBatteryOptimization) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_hasAskedToDisableBatteryOptimizationKey,
        hasAskedToDisableBatteryOptimization);
  }

  Future<bool> loadHasAskedToDisableBatteryOptimization() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool? hasAskedToDisableBatteryOptimization =
        preferences.getBool(_hasAskedToDisableBatteryOptimizationKey);
    return hasAskedToDisableBatteryOptimization ?? false;
  }
}
