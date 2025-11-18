import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/home.dart';
import 'providers/todo_provider.dart';

class App extends StatelessWidget {
  final TodoProvider provider;
  const App({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoProvider>.value(
      value: provider,
      child: MaterialApp(
        title: 'Tarefas',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
