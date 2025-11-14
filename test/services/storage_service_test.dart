import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/tark.dart';
import 'package:todo_app/services/storage_service.dart';
import 'package:todo_app/models/todo_list.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saveAllLists and loadAllLists', () async {
    final service = StorageService();
    final list = [
      TodoList(id: '1', name: 'L1', tasks: [Task(id: 'a', title: 'Tarefa')]),
    ];

    await service.saveAllLists(list);

    final loaded = await service.loadAllLists();
    expect(loaded.length, 1);
    expect(loaded.first.name, 'L1');
    expect(loaded.first.tasks.length, 1);
  });

  test('saveCurrentList and loadCurrentList', () async {
    final service = StorageService();
    final todo = TodoList(id: '2', name: 'Atual', tasks: []);

    await service.saveCurrentList(todo);
    final loaded = await service.loadCurrentList();

    expect(loaded!.id, '2');
    expect(loaded.name, 'Atual');
  });
}
