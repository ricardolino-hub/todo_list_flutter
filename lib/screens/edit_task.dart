import 'package:flutter/material.dart';
import 'package:todo_app/models/tark.dart';

class EditTaskScreen extends StatefulWidget {
  final Task? task;
  const EditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = TextEditingController(text: widget.task?.title ?? '');
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova tarefa' : 'Editar tarefa'),
        actions: [
          TextButton(
            onPressed: () {
              final text = _ctl.text.trim();
              if (text.isEmpty) return;
              final t = widget.task == null
                  ? null
                  : Task(id: widget.task!.id, title: text, done: widget.task!.done);
              Navigator.of(context).pop({'title': text, 'task': t});
            },
            child: Text('Salvar', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: _ctl,
          autofocus: true,
          decoration: InputDecoration(labelText: 'Título'),
          onSubmitted: (_) => null,
        ),
      ),
    );
  }
}
