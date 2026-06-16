import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'recent_searches_provider.g.dart';

@riverpod
class RecentSearches extends _$RecentSearches {
  static const int _maxRecent = 10;
  static const String _storageKey = 'recent_searches';

  @override
  List<String> build() {
    _loadFromStorage();
    return [];
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey);
    if (saved != null && saved.isNotEmpty) {
      state = saved;
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, state);
  }

  void add(String username) {
    if (username.trim().isEmpty) return;
    final trimmed = username.trim().toLowerCase();
    final updated = [
      trimmed,
      ...state.where((u) => u != trimmed),
    ];
    state = updated.take(_maxRecent).toList();
    _saveToStorage();
  }

  void remove(String username) {
    state = state.where((u) => u != username).toList();
    _saveToStorage();
  }

  void clear() {
    state = [];
    _saveToStorage();
  }
}
