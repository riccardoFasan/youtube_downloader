import 'package:get/get.dart';
import 'package:youtube_downloader/services/services.dart';

class SettingsController extends GetxController {
  final FileSystemService _fs = Get.find<FileSystemService>();

  final RxInt _downloadsQueueSize = 3.obs;
  int get downloadsQueueSize => _downloadsQueueSize.value;

  final RxBool _shouldSkipSponsors = true.obs;
  bool get shouldSkipSponsors => _shouldSkipSponsors.value;

  Future<void> init() async {
    _downloadsQueueSize.value = await _fs.readDownloadsQueueSize();
    _shouldSkipSponsors.value = await _fs.readShouldSkipSponsors();
  }

  Future<void> setDownloadsQueueSize(int queueSize) async {
    _downloadsQueueSize.value = queueSize;
    await _storeDownloadsQueueSize(queueSize);
  }

  Future<void> setShouldSkipSponsors(bool shouldSkipSponsors) async {
    _shouldSkipSponsors.value = shouldSkipSponsors;
    await _storeShouldSkipSponsors(shouldSkipSponsors);
  }

  Future<void> _storeDownloadsQueueSize(int queueSize) async {
    await _fs.updateDownloadsQueueSize(queueSize);
  }

  Future<void> _storeShouldSkipSponsors(bool shouldSkipSponsors) async {
    await _fs.updateShouldSkipSponsors(shouldSkipSponsors);
  }
}
