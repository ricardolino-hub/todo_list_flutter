import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class ListDrawer extends StatelessWidget {
  const ListDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TodoProvider>(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(title: Text('Listas salvas'), leading: Icon(Icons.list)),
            Expanded(
              child: ListView(
                children: prov.savedLists.map((l) {
                  return ListTile(
                    title: Text(l.name),
                    subtitle: Text('${l.tasks.length} tarefas'),
                    onTap: () {
                      prov.switchToSavedList(l.id);
                      Navigator.of(context).pop();
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        prov.deleteSavedList(l.id);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.save),
              title: Text('Salvar lista atual'),
              onTap: () async {
                final name = await _askName(context, prov.current.name);
                if (name != null && name.trim().isNotEmpty) {
                  final success = prov.saveCurrentAs(name.trim());
                  final snack = success ? 'Lista salva' : 'Já existem ${3} listas salvas (limite)';
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.create_new_folder),
              title: Text('Nova lista vazia'),
              onTap: () async {
                final name = await _askName(context, 'Nova lista');
                if (name != null && name.trim().isNotEmpty) {
                  final success = prov.createNewEmptyList(name.trim());
                  final snack = success ? 'Lista salva' : 'Já existem ${3} listas salvas (limite)';
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _askName(BuildContext context, String initial) {
    final ctl = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Nome da lista'),
        content: TextField(controller: ctl, decoration: InputDecoration(labelText: 'Nome')),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(ctl.text), child: Text('Ok')),
        ],
      ),
    );
  }
}
