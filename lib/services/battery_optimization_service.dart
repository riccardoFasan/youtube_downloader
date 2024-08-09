import 'package:get/get.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:youtube_downloader/services/services.dart';

class BatteryOptimizationService {
  final DevicePermissionsStorageService _devicePermissionsStorage =
      Get.find<DevicePermissionsStorageService>();

  Future<void> askToDisableOptimization() async {
    final bool hasAskedToDisableOptimization = await _devicePermissionsStorage
        .loadHasAskedToDisableBatteryOptimization();
    if (hasAskedToDisableOptimization) return;

    final bool optimizationIgnored =
        await OptimizeBattery.isIgnoringBatteryOptimizations();
    if (optimizationIgnored) return;

    await OptimizeBattery.stopOptimizingBatteryUsage();

    await _devicePermissionsStorage
        .storeHasAskedToDisableBatteryOptimization(true);
  }
}
