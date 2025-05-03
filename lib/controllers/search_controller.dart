import 'package:get/get.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/services/services.dart';

class VideoSearchController extends GetxController {
  final YouTubeService _yt = Get.find<YouTubeService>();
  final SnackbarService _snackbar = Get.find<SnackbarService>();

  final RxList<AudioInfo> _results = <AudioInfo>[].obs;
  List<AudioInfo> get results => _results;

  final Rx<bool> _loadingFirstBatch = false.obs;
  bool get loadingFirstBatch => _loadingFirstBatch.value;

  final Rx<bool> _loadingNextBatch = false.obs;
  bool get loadingNextBatch => _loadingNextBatch.value;

  final Rx<String> _query = ''.obs;
  String get query => _query.value;

  static const int _minQueryLength = 3;

  bool get canLoadNextBatch =>
      _results.isNotEmpty && _results.length % _yt.batchSize == 0;

  @override
  void onInit() {
    _yt.openSearchSession();
    super.onInit();
  }

  @override
  void dispose() {
    _yt.closeSearchSession();
    super.dispose();
  }

  Future<void> search(String query) async {
    if (query.length < _minQueryLength) return;
    _query.value = query;
    _loadingFirstBatch.value = true;
    try {
      final List<AudioInfo> results = await _yt.search(query.trim());
      _results.value = results;
    } catch (e) {
      _results.value = [];
    } finally {
      _loadingFirstBatch.value = false;
    }
  }

  Future<void> nextSearchBatch() async {
    _loadingNextBatch.value = true;
    try {
      final List<AudioInfo> results = await _yt.nextPage();
      _results.value = [..._results, ...results];
    } catch (e) {
      _snackbar.showSearchError();
    } finally {
      _loadingNextBatch.value = false;
    }
  }

  void clear() {
    _results.value = [];
    _query.value = '';
    _loadingFirstBatch.value = false;
    _loadingNextBatch.value = false;
  }
}
