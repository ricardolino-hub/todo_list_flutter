import 'package:flutter/material.dart';
import 'app.dart';
import 'services/storage_service.dart';
import 'providers/todo_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  final prov = await TodoProvider.create(storage);
  runApp(App(provider: prov));
}
