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

  final RxList<Download> _downloads = <Download>[].obs;
  List<Download> get downloads => _downloads;

  final Map<String, StreamSubscription<void>> _subscriptions = {};

  AudiosViewModel() {
    _init();
  }

  Future<void> download(String url) async {
    // TODO: verify it's a valid url (e.g. not a live) and not already downloaded
    _subscriptions[url] = _getAudioAndSave(url).asStream().listen((_) {
      _subscriptions.remove(url);
    });
  }

  void cancelDownload(Download download) {
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

  Future<void> play(Audio audio) async {
    await _player.setCurrentAudioAndPlay(audio);
  }

  Future<void> _getAudioAndSave(String url) async {
    _addDownload(Download(url: url));
    try {
      final AudioInfo info = await _yt.getInfo(url);
      _addDownloadInfo(info);
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
    } catch (e) {
      _snackbar.showError();
    } finally {
      _removeDownload(url);
    }
  }

  void _addDownload(Download download) {
    _downloads.value = [download, ..._downloads];
  }

  void _addDownloadInfo(AudioInfo info) {
    final Download download =
        _downloads.firstWhere((Download d) => d.url == info.url);
    _removeDownload(info.url);
    _downloads.value = [..._downloads, Download(url: download.url, info: info)];
  }

  void _removeDownload(String url) {
    _downloads.removeWhere((Download d) => d.url == url);
  }

  void _addAudio(Audio audio) {
    _audios.value = [audio, ..._audios];
    _update();
  }

  void _removeAudio(Audio audio) {
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
