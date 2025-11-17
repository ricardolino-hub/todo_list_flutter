import 'package:todo_app/models/tark.dart';

class TodoList {
  String id;
  String name;
  List<Task> tasks;

  TodoList({
    required this.id,
    required this.name,
    required this.tasks,
  });

  factory TodoList.fromJson(Map<String, dynamic> j) => TodoList(
    id: j['id'] as String,
    name: j['name'] as String,
    tasks: (j['tasks'] as List<dynamic>).map((e) => Task.fromJson(e as Map<String, dynamic>)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (other is TodoList) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}
