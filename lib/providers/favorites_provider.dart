import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  List<Place> _favoritePlaces = [];
  static const _favoritesKey = 'favorite_places';
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  FavoritesProvider() {
    // Muat favorit dari penyimpanan saat provider pertama kali dibuat.
    _loadFavorites();
  }

  List<Place> get favoritePlaces => _favoritePlaces;

  bool isFavorite(Place place) {
    // Check if a place with the same id is already in the list
    return _favoritePlaces.any((p) => p.id == place.id);
  }

  Future<void> toggleFavorite(Place place) async {
    if (isFavorite(place)) {
      _favoritePlaces.removeWhere((p) => p.id == place.id);
    } else {
      _favoritePlaces.add(place);
    }
    // Simpan daftar yang sudah diperbarui dan kemudian beri tahu UI.
    await _saveFavorites();
    notifyListeners();
  }

  /// Menyimpan daftar favorit saat ini ke SharedPreferences.
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Ubah daftar objek Place menjadi daftar String JSON.
    final List<String> favoritesJson =
        _favoritePlaces.map((place) => jsonEncode(place.toJson())).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  /// Memuat daftar favorit dari SharedPreferences.
  Future<void> _loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList(_favoritesKey);
    if (favoritesJson != null) {
      // Ubah daftar String JSON kembali menjadi daftar objek Place.
      _favoritePlaces = favoritesJson.map((jsonString) => Place.fromJson(jsonDecode(jsonString))).toList();
    }
    _isLoading = false;
    // Beri tahu UI bahwa data awal telah dimuat.
    notifyListeners();
  }
}