import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorageService {
  static const String _downloadsQueueSizeKey = 'downloadsQueueSize';
  static const String _shouldSkipSponsorsKey = 'shouldSkipSponsors';

  Future<void> storeDownloadsQueueSize(int queueSize) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_downloadsQueueSizeKey, queueSize);
  }

  Future<int> loadDownloadsQueueSize() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int? queueSize = preferences.getInt(_downloadsQueueSizeKey);
    return queueSize ?? 3;
  }

  Future<void> storeShouldSkipSponsors(bool shouldSkipSponsors) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_shouldSkipSponsorsKey, shouldSkipSponsors);
  }

  Future<bool> loadShouldSkipSponsors() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool? shouldSkipSponsors =
        preferences.getBool(_shouldSkipSponsorsKey);
    return shouldSkipSponsors ?? true;
  }
}
