import 'package:get/get.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/services/services.dart';

class AudiosViewModel extends GetxController {
  final StorageService _storage = Get.find();
  final YouTubeService _yt = Get.find();
  final FileSystemService _fs = Get.find();

  final RxList<Audio> _audios = <Audio>[].obs;
  List<Audio> get audios => _audios;

  final RxList<Download> _downloads = <Download>[].obs;
  List<Download> get downloads => _downloads;

  AudiosViewModel() {
    _init();
  }

  Future<void> download(String url) async {
    // TODO: verify it's a valid url (e.g. not a live) and not already downloaded
    _addDownload(Download(url: url));
    final AudioInfo info = await _yt.getInfo(url);
    _addInfoToDownload(info);
    final Stream<List<int>> stream = await _yt.download(info.id);
    final String path = await _fs.saveAudioFile(info, stream);
    final Audio audio = Audio(
      id: info.id,
      url: info.url,
      title: info.title,
      channel: info.channel,
      thumbnailUrl: info.thumbnailUrl,
      path: path,
    );
    _removeDownload(url);
    _addAudio(audio);
  }

  Future<void> delete(Audio audio) async {
    await _fs.removeAudioFile(audio);
    _removeAudio(audio);
  }

  void open(Audio audio) {
    _fs.openAudioFile(audio);
  }

  void _addDownload(Download download) {
    _downloads.value = [download, ..._downloads];
  }

  void _addInfoToDownload(AudioInfo info) {
    final Download download =
        _downloads.firstWhere((Download d) => d.url == info.url);
    _removeDownload(info.url);
    _downloads.value = [..._downloads, download];
  }

  void _removeDownload(String url) {
    _downloads.removeWhere((Download d) => d.url == url);
  }

  void _addAudio(Audio audio) {
    _audios.value = [audio, ..._audios];
    _updateStore();
  }

  void _removeAudio(Audio audio) {
    _audios.removeWhere((Audio a) => a.id == audio.id);
    _updateStore();
  }

  Future<void> _init() async {
    _audios.value = await _storage.load();
  }

  Future<void> _updateStore() async {
    await _storage.store(_audios);
  }
}
