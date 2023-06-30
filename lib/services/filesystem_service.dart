import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_downloader/models/models.dart';

class FileSystemService {
  static const String fileExtension = 'mp3';

  Future<String> saveAudioFileFromBytes(AudioInfo info, List<int> bytes) async {
    final String path = await _getFilePath(info.id);
    final File file = File(path);
    await file.writeAsBytes(bytes);
    return path;
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
    return '$path/$audioId.$fileExtension';
  }
}
