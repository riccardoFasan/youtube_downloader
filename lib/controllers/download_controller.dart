import 'dart:async';
import 'package:get/get.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/services/services.dart';

class DownloadController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final SnackbarService _snackbar = Get.find<SnackbarService>();
  final YouTubeService _yt = Get.find<YouTubeService>();
  final FileSystemService _fs = Get.find<FileSystemService>();
  final SponsorblockService _sponsorblock = Get.find<SponsorblockService>();
  final NotificationsService _notifications = Get.find<NotificationsService>();
  final LifecycleService _lifecycle = Get.find<LifecycleService>();

  final RxList<Audio> _audios = <Audio>[].obs;
  List<Audio> get audios => _audios;

  final RxList<AudioInfo> _downloads = <AudioInfo>[].obs;
  List<AudioInfo> get downloads => _downloads;

  final Map<String, StreamSubscription<void>> _subscriptions = {};

  DownloadController() {
    _init();
  }

  Future<void> download(AudioInfo info) async {
    _subscriptions[info.url] = _getAudioAndSave(info).asStream().listen((_) {
      _subscriptions.remove(info.url);
    });
  }

  void cancelDownload(AudioInfo download) {
    final String url = download.url;
    if (_subscriptions.containsKey(url)) {
      _subscriptions[url]!.cancel();
      _subscriptions.remove(url);
      _removeDownload(url);
    }
  }

  Future<void> delete(Audio audio) async {
    await _fs.removeAudioFile(audio);
    _removeAudio(audio);
  }

  bool isDownloading(AudioInfo info) {
    return _downloads.any((AudioInfo d) => d.id == info.id);
  }

  bool isSaved(AudioInfo info) {
    return _audios.any((AudioInfo d) => d.id == info.id);
  }

  Future<void> _getAudioAndSave(AudioInfo info) async {
    _addDownload(info);
    final int? notificationId =
        await _notifications.showDownloadInProgress(info.title);
    try {
      final [bytes, sponsorships] = await Future.wait([
        _yt.download(info.id),
        _sponsorblock.getSponsorships(info.id),
      ]);

      final String path =
          await _fs.saveAudioFileFromBytes(info, bytes as List<int>);

      final List<Segment> segments = (sponsorships as Sponsorships).segments;

      final Audio audio = Audio(
        id: info.id,
        url: info.url,
        title: info.title,
        channel: info.channel,
        duration: info.duration,
        thumbnailUrl: info.thumbnailUrl,
        path: path,
        sponsorsedSegments: segments,
      );

      _addAudio(audio);
      _notifyDownloadCompleted(info);
    } catch (e) {
      _notifyDownloadError(info);
    } finally {
      _removeDownload(info.url);
      if (notificationId != null) {
        await _notifications.cancelNotification(notificationId);
      }
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
    _audios.removeWhere((Audio a) => a.id == audio.id);
    _update();
  }

  Future<void> _init() async {
    _audios.value = await _storage.load();
  }

  Future<void> _update() async {
    await _storage.store(_audios);
  }

  Future<void> _notifyDownloadCompleted(AudioInfo info) async {
    if (_lifecycle.active) {
      _snackbar.showDownloadCompletd(info.title);
      return;
    }
    _notifications.showDownloadCompleted(info.title);
  }

  Future<void> _notifyDownloadError(AudioInfo info) async {
    if (_lifecycle.active) {
      _snackbar.showDownloadError();
      return;
    }
    _notifications.showDownloadFailed(info.title);
  }
}
