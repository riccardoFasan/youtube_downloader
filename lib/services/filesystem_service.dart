import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_downloader/models/models.dart';

class FileSystemService {
  static const String _audioFileExtension = 'mp3';
  static const String _jsonFileExtension = 'json';

  static const String _audioListFileName = 'audios';
  static const String _preferencesFileName = 'preferences';

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

  Future<int> readDownloadsQueueSize() async {
    final dynamic preferences = await _readPreferences();
    return preferences['downloadsQueueSize'];
  }

  Future<void> updateDownloadsQueueSize(int queueSize) async {
    final bool shouldSkipSponsors = await readShouldSkipSponsors();
    _updatePreferences({
      'shouldSkipSponsors': shouldSkipSponsors,
      'downloadsQueueSize': queueSize
    });
  }

  Future<bool> readShouldSkipSponsors() async {
    final dynamic preferences = await _readPreferences();
    return preferences['shouldSkipSponsors'];
  }

  Future<void> updateShouldSkipSponsors(bool shouldSkipSponsors) async {
    final int downloadsQueueSize = await readDownloadsQueueSize();
    _updatePreferences({
      'shouldSkipSponsors': shouldSkipSponsors,
      'downloadsQueueSize': downloadsQueueSize
    });
  }

  Future<void> saveAudioList(List<Audio> audios) async {
    final String content = jsonEncode(audios.map((a) => a.toJson()).toList());
    await _createOrUpdateJsonFile(_audioListFileName, content);
  }

  Future<dynamic> _readPreferences() async {
    final String filePath =
        _getFilePath(_preferencesFileName, _jsonFileExtension);
    final bool exists = await _fileExists(filePath);
    if (!exists) return {'shouldSkipSponsors': true, 'downloadsQueueSize': 3};
    return await _readJsonFile(filePath);
  }

  Future<void> _updatePreferences(dynamic preferences) async {
    final String filePath =
        _getFilePath(_preferencesFileName, _jsonFileExtension);
    await _writeJsonFile(filePath, preferences);
  }

  Future<List<Audio>> readAudioList() async {
    final String filePath =
        _getFilePath(_audioListFileName, _jsonFileExtension);
    final bool exists = await _fileExists(filePath);
    if (!exists) return [];

    final dynamic content = await _readJsonFile(filePath);
    final List<Audio> audioList =
        List<Audio>.from(content.map((a) => Audio.fromJson(a)));

    final Iterable<Future<Audio?>> validFilesFutures =
        audioList.map((audio) async {
      final bool valid = await _isValidAudioFile(audio);
      if (valid) return audio;
      return null;
    });

    final Iterable<Audio?> validFiles = await Future.wait(validFilesFutures);
    return validFiles.whereType<Audio>().toList();
  }

  Future<bool> _isValidAudioFile(Audio audio) async {
    final String path = _getFilePath(audio.id, _audioFileExtension);
    return await _fileExists(path);
  }

  Future<String> _createOrUpdateJsonFile(
      String fileName, String content) async {
    final String filePath = _getFilePath(fileName, _jsonFileExtension);
    final bool exists = await _fileExists(filePath);
    if (!exists) await _createFile(filePath);
    await _writeJsonFile(filePath, content);
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

  Future<dynamic> _readJsonFile(String path) async {
    final File file = File(path);
    final String content = await file.readAsString();
    return jsonDecode(content);
  }

  Future<void> _writeJsonFile(String path, dynamic content) async {
    final File file = File(path);
    await file.writeAsString(jsonEncode(content));
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
