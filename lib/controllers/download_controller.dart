import 'dart:async';
import 'package:get/get.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/services/services.dart';

class DownloadController extends GetxController {
  final SnackbarService _snackbar = Get.find<SnackbarService>();
  final YouTubeService _yt = Get.find<YouTubeService>();
  final FileSystemService _fs = Get.find<FileSystemService>();
  final SponsorblockService _sponsorblock = Get.find<SponsorblockService>();
  final NotificationsService _notifications = Get.find<NotificationsService>();
  final LifecycleService _lifecycle = Get.find<LifecycleService>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  final RxList<Audio> _audios = <Audio>[].obs;
  List<Audio> get audios => _audios;

  final RxList<Download> _downloads = <Download>[].obs;
  List<Download> get downloads => _downloads;

  final Map<String, StreamSubscription<void>> _subscriptions = {};

  bool get _isQueueFull =>
      _downloads.length >= _settingsController.downloadsQueueSize;

  Future<void> init() async {
    _audios.value = await _fs.readAudioList();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final Audio audio = _audios.removeAt(oldIndex);
    final int targetIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    _audios.insert(targetIndex, audio);
    _update();
  }

  Future<void> download(AudioInfo info) async {
    _subscriptions[info.url] = _getAudioAndSave(info).asStream().listen((_) {
      _subscriptions.remove(info.url);
    });
  }

  void cancelDownload(Download download) {
    final String url = download.url;
    if (_subscriptions.containsKey(url)) {
      _subscriptions[url]!.cancel();
      _subscriptions.remove(url);
      _removeDownload(download);
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
    if (_isQueueFull) {
      _snackbar.showDownloadsQueueError();
      return;
    }

    final Download download = Download(
        id: info.id,
        url: info.url,
        title: info.title,
        channel: info.channel,
        duration: info.duration,
        thumbnailMaxResUrl: info.thumbnailMaxResUrl,
        thumbnailMinResUrl: info.thumbnailMinResUrl,
        progress: 0.obs);

    _addDownload(download);
    final int? notificationId =
        await _notifications.showDownloadInProgress(info.title);
    try {
      final [bytes, sponsorships] = await Future.wait([
        _getBytesAndUpdateProgress(download),
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
        thumbnailMaxResUrl: info.thumbnailMaxResUrl,
        thumbnailMinResUrl: info.thumbnailMinResUrl,
        path: path,
        sponsorsedSegments: segments,
      );

      _addAudio(audio);
      _notifyDownloadCompleted(info);
    } catch (e) {
      _notifyDownloadError(info);
    } finally {
      _removeDownload(download);
      if (notificationId != null) {
        await _notifications.cancelNotification(notificationId);
      }
    }
  }

  void _addDownload(Download download) {
    _downloads.value = [download, ..._downloads];
  }

  void _removeDownload(Download download) {
    _downloads.removeWhere((Download d) => d.id == download.id);
  }

  void _addAudio(Audio audio) {
    _audios.value = [audio, ..._audios];
    _update();
  }

  void _removeAudio(Audio audio) {
    _audios.removeWhere((Audio a) => a.id == audio.id);
    _update();
  }

  Future<void> _update() async {
    await _fs.saveAudioList(_audios);
  }

  Future<List<int>> _getBytesAndUpdateProgress(Download download) async {
    final DownloadResult downloadResult = await _yt.download(download.id);
    final List<int> bytes = [];
    await for (final List<int> chunk in downloadResult.stream) {
      bytes.addAll(chunk);
      final int progress = ((bytes.length / downloadResult.size) * 100).ceil();
      download.progress.value = progress;
    }
    return bytes;
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
