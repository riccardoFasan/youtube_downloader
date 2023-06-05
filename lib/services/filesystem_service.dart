import 'dart:io';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yuotube_downloader/models/models.dart';

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

  void openAudioFile(Audio audio) async {
    final String path = await _getFilePath(audio.id);
    await OpenFile.open(path);
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
