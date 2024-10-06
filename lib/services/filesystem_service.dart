import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_downloader/models/models.dart';

class FileSystemService {
  static const String _audioFileExtension = 'mp3';
  static const String _jsonFileExtension = 'json';
  static const String _localPath = '/storage/emulated/0/YouTubeDownloader';

  bool _authorized = false;

  Future<void> init() async {
    _authorized = await _hasStoragePermission();
    if (_authorized) return;
    _authorized = await _requestStoragePermission();

    final bool exists = await _directoryExists(_localPath);
    if (exists) return;
    await _createDirectory(_localPath);
  }

  Future<String> saveAudioFileFromBytes(AudioInfo info, List<int> bytes) async {
    final String path = _getFilePath(info.id, _audioFileExtension);
    final File file = File(path);
    await file.writeAsBytes(bytes);
    return path;
  }

  Future<void> removeAudioFile(Audio audio) async {
    final String path = _getFilePath(audio.id, _audioFileExtension);
    await File(path).delete();
  }

  Future<String> createOrUpdateJsonFile(String fileName, String content) async {
    final String filePath = _getFilePath(fileName, _jsonFileExtension);
    final bool exists = await _fileExists(filePath);
    if (!exists) await _createFile(filePath);
    final File file = File(filePath);
    await file.writeAsString(content);
    return filePath;
  }

  String _getFilePath(String fileName, String fileExtension) {
    return '$_localPath/$fileName.$fileExtension';
  }

  Future<bool> _directoryExists(String path) async {
    final Directory directory = Directory(_localPath);
    return await directory.exists();
  }

  Future<void> _createDirectory(String path) async {
    final Directory directory = Directory(path);
    await directory.create();
  }

  Future<bool> _fileExists(String path) async {
    final File file = File(path);
    return await file.exists();
  }

  Future<void> _createFile(String path) async {
    final File file = File(path);
    await file.create();
  }

  Future<bool> _hasStoragePermission() async {
    final PermissionStatus result =
        await Permission.manageExternalStorage.status;
    return !!result.isGranted;
  }

  Future<bool> _requestStoragePermission() async {
    final PermissionStatus result =
        await Permission.manageExternalStorage.request();
    return !!result.isGranted;
  }
}
