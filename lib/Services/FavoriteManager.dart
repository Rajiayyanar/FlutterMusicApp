import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager {
  static List favorites = [];

  static Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('favorites');

    if (data != null) {
      List decoded = jsonDecode(data);
      favorites = decoded;
    }
  }

  static Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', jsonEncode(favorites));
  }

  static Future<void> add(song) async {
    if (!favorites.any((s) => s['videoId'] == song.videoId)) {
      favorites.add({
        "title": song.title,
        "channel": song.channel,
        "image": song.image,
        "videoId": song.videoId,
      });
      await saveFavorites();
    }
  }

  static Future<void> remove(song) async {
    favorites.removeWhere((s) => s['videoId'] == song['videoId']);
    await saveFavorites();
  }

  static bool isFavorite(song) {
    return favorites.any((s) => s['videoId'] == song.videoId);
  }
}