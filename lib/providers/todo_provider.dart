import 'package:flutter/material.dart';
import 'package:todo_app/models/tark.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_list.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class TodoProvider extends ChangeNotifier {
  final StorageService storage;
  TodoList current;
  List<TodoList> savedLists;

  TodoProvider({required this.storage, required TodoList? initial, required this.savedLists})
      : current = initial ?? TodoList(id: Uuid().v4(), name: 'Lista atual', tasks: []);

  // Load from storage helper
  static Future<TodoProvider> create(StorageService storage) async {
    final saved = await storage.loadAllLists();
    final cur = await storage.loadCurrentList();
    return TodoProvider(storage: storage, initial: cur, savedLists: saved);
  }

  void addTask(String title) {
    if (current.tasks.length >= Constants.max_tasks_per_list) return;
    current.tasks.add(Task(id: Uuid().v4(), title: title, done: false));
    if (savedLists.isNotEmpty && savedLists.contains(current)) savedLists.firstWhere((l) => l.id == current.id).tasks.add(Task(id: Uuid().v4(), title: title, done: false));
    _saveAll();
    notifyListeners();
  }

  void updateTask(Task t) {
    final idx = current.tasks.indexWhere((e) => e.id == t.id);
    if (idx >= 0) {
      current.tasks[idx] = t;
      if (savedLists.isNotEmpty  && savedLists.contains(current)) savedLists.firstWhere((l) => l.id == current.id).tasks[idx] = t;
      _saveAll();
      notifyListeners();
    }
  }

  void toggleDone(String id, bool value) {
    final idx = current.tasks.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      current.tasks[idx].done = value;
      if (savedLists.isNotEmpty  && savedLists.contains(current)) savedLists.firstWhere((l) => l.id == current.id).tasks[idx].done = value;
      _saveAll();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    current.tasks.removeWhere((e) => e.id == id);
    if (savedLists.isNotEmpty  && savedLists.contains(current)) savedLists.firstWhere((l) => l.id == current.id).tasks.removeWhere((e) => e.id == id);
    _saveAll();
    notifyListeners();
  }

  void editTask(String id, String newTitle) {
    final idx = current.tasks.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      current.tasks[idx].title = newTitle;
      if (savedLists.isNotEmpty && savedLists.contains(current)) savedLists.firstWhere((l) => l.id == current.id).tasks[idx].title = newTitle;
      _saveAll();
      notifyListeners();
    }
  }

  // Lists management (max 3)
  bool saveCurrentAs(String name) {
    if (savedLists.length >= Constants.max_lists) return false;
    final copy = TodoList(id: current.id, name: name, tasks: current.tasks.map((t) => Task(id: t.id, title: t.title, done: t.done)).toList());
    savedLists.add(copy);
    _saveAllLists();
    return true;
  }

  void overwriteSavedList(String id, TodoList newList) {
    final idx = savedLists.indexWhere((l) => l.id == id);
    if (idx >= 0) savedLists[idx] = newList;
    _saveAllLists();
    notifyListeners();
  }

  void deleteSavedList(String id) {
    savedLists.removeWhere((l) => l.id == id);
    _saveAllLists();
    notifyListeners();
  }

  void switchToSavedList(String id) {
    _saveAll();
    final found = savedLists.firstWhere((l) => l.id == id, orElse: () => savedLists.isNotEmpty ? savedLists.first : current);
    // print("switchToSavedList: ${found.toJson()}");
    current = TodoList(id: found.id, name: found.name, tasks: found.tasks.map((t) => Task(id: t.id, title: t.title, done: t.done)).toList());
    notifyListeners();
  }

  void createNewEmptyList(String name) {
    current = TodoList(id: Uuid().v4(), name: name, tasks: []);
    _saveCurrent();
    notifyListeners();
  }

  // Persistence
  Future<void> _saveAll() async {
    await _saveCurrent();
    await _saveAllLists();
  }

  Future<void> _saveCurrent() async {
    await storage.saveCurrentList(current);
  }

  Future<void> _saveAllLists() async {
    await storage.saveAllLists(savedLists);
  }
}
