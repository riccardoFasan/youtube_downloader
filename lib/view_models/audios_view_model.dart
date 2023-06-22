import 'dart:async';
import 'package:get/get.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/services/services.dart';
import 'package:yuotube_downloader/view_models/player_view_model.dart';

class AudiosViewModel extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final SnackbarService _snackbar = Get.find<SnackbarService>();
  final YouTubeService _yt = Get.find<YouTubeService>();
  final FileSystemService _fs = Get.find<FileSystemService>();
  final SponsorblockService _sponsorblock = Get.find<SponsorblockService>();
  final TrimmerService _trimmer = Get.find<TrimmerService>();
  final PlayerViewModel _player = Get.find<PlayerViewModel>();

  final RxList<Audio> _audios = <Audio>[].obs;
  List<Audio> get audios => _audios;

  final RxList<AudioInfo> _downloads = <AudioInfo>[].obs;
  List<AudioInfo> get downloads => _downloads;

  final Map<String, StreamSubscription<void>> _subscriptions = {};

  AudiosViewModel() {
    _init();
  }

  Future<void> download(AudioInfo info) async {
    _subscriptions[info.url] = _getAudioAndSave(info).asStream().listen((_) {
      _subscriptions.remove(info.url);
    });
  }

  void cancelDownload(AudioInfo download) {
    final String url = download.url;
    if (!_subscriptions.containsKey(url)) return;
    final StreamSubscription<void> subscription = _subscriptions[url]!;
    subscription.cancel();
    _subscriptions.remove(url);
    _removeDownload(url);
  }

  Future<void> delete(Audio audio) async {
    await _fs.removeAudioFile(audio);
    _removeAudio(audio);
  }

  bool isDownloading(AudioInfo info) {
    return _downloads.any((AudioInfo d) => d.id == info.id);
  }

  Future<void> _getAudioAndSave(AudioInfo info) async {
    _addDownload(info);
    try {
      final List<int> bytes = await _yt.download(info.id);
      final String path = await _fs.saveAudioFileFromBytes(info, bytes);
      final Sponsorships sponsorships =
          await _sponsorblock.getSponsorships(info.id);
      final Audio audio = Audio(
          id: info.id,
          url: info.url,
          title: info.title,
          channel: info.channel,
          duration: info.duration,
          thumbnailUrl: info.thumbnailUrl,
          path: path);
      await _trimmer.removeSegments(audio, sponsorships.segments);

      _addAudio(audio);
      _snackbar.showDownloadCompletd(audio.title);
    } catch (e) {
      _snackbar.showDownloadError();
    } finally {
      _removeDownload(info.url);
    }
  }

  void _addDownload(AudioInfo download) {
    _downloads.value = [download, ..._downloads];
  }

  void _removeDownload(String url) {
    _downloads.removeWhere((AudioInfo d) => d.url == url);
  }

  void _addAudio(Audio audio) {
    _audios.value = [audio, ..._audios];
    _update();
  }

  void _removeAudio(Audio audio) {
    if (_player.isSelected(audio)) _player.stop();
    _audios.removeWhere((Audio a) => a.id == audio.id);
    _update();
  }

  Future<void> _init() async {
    _audios.value = await _storage.load();
  }

  Future<void> _update() async {
    await _storage.store(_audios);
  }
}
