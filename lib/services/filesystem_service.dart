import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:yuotube_downloader/models/models.dart';

class FileSytemService {
  static const String extension = 'mp3';

  Future<Uri> saveAudioFile(AudioInfo info, Stream<List<int>> stream) async {
    final String path = await _getFilePath(info.id);
    stream.pipe(File(path).openWrite());
    return Uri.file(path);
  }

  Future<void> removeAudioFile(Audio audio) async {
    final String path = await _getFilePath(audio.id);
    await File(path).delete();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> _getFilePath(String audioId) async {
    final String path = await _localPath;
    return '$path/$audioId.$extension';
  }
}
