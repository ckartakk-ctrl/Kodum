import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences sarmalayıcı: WPM ve okuma ilerlemesi kalıcıdır.
class StorageService {
  static const _wpmKey = 'default_wpm';
  static const _progressPrefix = 'progress_';

  static Future<int> loadWpm({int fallback = 250}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_wpmKey) ?? fallback;
  }

  static Future<void> saveWpm(int wpm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_wpmKey, wpm);
  }

  static Future<void> saveProgress(String bookTitle, int percent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_progressPrefix$bookTitle', percent);
  }

  static Future<Map<String, int>> loadAllProgress(List<String> titles) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final t in titles) t: prefs.getInt('$_progressPrefix$t') ?? 0,
    };
  }
}
