import 'package:get/get.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/services/services.dart';

class SearchViewModel extends GetxController {
  final YouTubeService _yt = Get.find<YouTubeService>();
  final SnackbarService _snackbar = Get.find<SnackbarService>();

  final RxList<AudioInfo> _results = <AudioInfo>[].obs;
  List<AudioInfo> get results => _results;

  final Rx<bool> _loading = false.obs;
  bool get loading => _loading.value;

  final Rx<String> _query = ''.obs;
  String get query => _query.value;

  static const int _minQueryLength = 3;

  Future<void> search(String query) async {
    if (query.length < _minQueryLength) return;
    _query.value = query;
    _loading.value = true;
    try {
      final List<AudioInfo> results = await _yt.search(query);
      _results.value = results;
    } catch (e) {
      _results.value = [];
      _snackbar.showSearchError();
    } finally {
      _loading.value = false;
    }
  }

  void clear() {
    _results.value = [];
    _query.value = '';
    _loading.value = false;
  }
}
