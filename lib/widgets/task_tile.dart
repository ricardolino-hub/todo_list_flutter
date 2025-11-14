import 'package:flutter/material.dart';
import 'package:todo_app/models/tark.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;

  const TaskTile({Key? key, required this.task, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: task.done, onChanged: onChanged),
      title: Text(
        task.title,
        style: TextStyle(decoration: task.done ? TextDecoration.lineThrough : null),
      ),
    );
  }
}
