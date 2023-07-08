import 'package:get/get.dart';
import 'package:youtube_downloader/services/services.dart';

class SettingsController extends GetxController {
  final SettingsStorageService _settingsStorage =
      Get.find<SettingsStorageService>();

  final RxInt _downloadsQueueSize = 3.obs;
  int get downloadsQueueSize => _downloadsQueueSize.value;

  final RxBool _shouldSkipSponsors = true.obs;
  bool get shouldSkipSponsors => _shouldSkipSponsors.value;

  SettingsController() {
    _init();
  }

  Future<void> setDownloadsQueueSize(int queueSize) async {
    _downloadsQueueSize.value = queueSize;
    await _storeDownloadsQueueSize(queueSize);
  }

  Future<void> setShouldSkipSponsors(bool shouldSkipSponsors) async {
    _shouldSkipSponsors.value = shouldSkipSponsors;
    await _storeShouldSkipSponsors(shouldSkipSponsors);
  }

  Future<void> _init() async {
    _downloadsQueueSize.value = await _settingsStorage.loadDownloadsQueueSize();
    _shouldSkipSponsors.value = await _settingsStorage.loadShouldSkipSponsors();
  }

  Future<void> _storeDownloadsQueueSize(int queueSize) async {
    await _settingsStorage.storeDownloadsQueueSize(queueSize);
  }

  Future<void> _storeShouldSkipSponsors(bool shouldSkipSponsors) async {
    await _settingsStorage.storeShouldSkipSponsors(shouldSkipSponsors);
  }
}
