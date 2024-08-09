import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_downloader/models/models.dart';

class AudiosStorageService {
  static const String _audioKey = 'audios';

  Future<void> storeAudios(List<Audio> audios) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String json = jsonEncode(audios.map((a) => a.toJson()).toList());
    await preferences.setString(_audioKey, json);
  }

  Future<List<Audio>> loadAudios() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? json = preferences.getString(_audioKey);
    if (json == null) return [];
    return List<Audio>.from(jsonDecode(json).map((a) => Audio.fromJson(a)));
  }
}
