import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/tark.dart';
import 'package:todo_app/screens/edit_task.dart';
import '../providers/todo_provider.dart';
import '../widgets/task_tile.dart';
import '../widgets/list_drawer.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _openEditor(BuildContext context, {Task? task}) async {
    final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)));
    if (res == null) return;
    final title = (res as Map)['title'] as String;
    final prov = Provider.of<TodoProvider>(context, listen: false);
    final existing = res['task'] as Task?;
    if (existing != null) {
      prov.editTask(existing.id, title);
    } else {
      prov.addTask(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (_, prov, __) {
      final list = prov.current;
      return Scaffold(
        appBar: AppBar(
          title: Text(list.name),
          leading: Builder(builder: (ctx) => IconButton(icon: Icon(Icons.menu), onPressed: () => Scaffold.of(ctx).openDrawer())),
        ),
        drawer: ListDrawer(),
        body: Column(
          children: [
            if (list.tasks.isEmpty)
              Padding(
                padding: EdgeInsets.all(24),
                child: Text('Nenhuma tarefa. Use o botão + para adicionar.'),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: list.tasks.length,
                itemBuilder: (ctx, i) {
                  final task = list.tasks[i];
                  return Dismissible(
                    key: Key(task.id),
                    background: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // edit
                        await _openEditor(context, task: task);
                        return false; // don't dismiss
                      } else {
                        // delete
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (dctx) => AlertDialog(
                            title: Text('Excluir tarefa?'),
                            content: Text('Deseja realmente excluir "${task.title}"?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(dctx).pop(false), child: Text('Não')),
                              TextButton(onPressed: () => Navigator.of(dctx).pop(true), child: Text('Sim')),
                            ],
                          ),
                        );
                        return ok == true;
                      }
                    },
                    onDismissed: (_) {
                      prov.deleteTask(task.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tarefa excluída')));
                    },
                    child: TaskTile(
                      task: task,
                      onChanged: (v) {
                        prov.toggleDone(task.id, v ?? false);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (prov.current.tasks.length >= 10) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Máximo de 10 tarefas por lista')));
              return;
            }
            await _openEditor(context);
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
