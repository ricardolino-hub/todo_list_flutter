import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_list.dart';
import '../utils/constants.dart';

class StorageService {
  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  Future<void> saveAllLists(List<TodoList> lists) async {
    final p = await _prefs();
    final map = lists.map((l) => l.toJson()).toList();
    p.setString(Constants.storage_key_lists, jsonEncode(map));
  }

  Future<List<TodoList>> loadAllLists() async {
    final p = await _prefs();
    final raw = p.getString(Constants.storage_key_lists);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => TodoList.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveCurrentList(TodoList list) async {
    final p = await _prefs();
    p.setString(Constants.storage_key_current, jsonEncode(list.toJson()));
  }

  Future<TodoList?> loadCurrentList() async {
    final p = await _prefs();
    final raw = p.getString(Constants.storage_key_current);
    if (raw == null) return null;
    return TodoList.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
