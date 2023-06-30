import 'dart:convert';
import 'package:youtube_downloader/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _audioKey = 'audios';

  Future<void> store(List<Audio> todos) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String json = jsonEncode(todos.map((t) => t.toJson()).toList());
    await preferences.setString(_audioKey, json);
  }

  Future<List<Audio>> load() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? json = preferences.getString(_audioKey);
    if (json == null) {
      return [];
    }
    return List<Audio>.from(jsonDecode(json).map((t) => Audio.fromJson(t)));
  }
}
