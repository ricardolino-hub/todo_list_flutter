import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService();
  });

  Future<TodoProvider> createProvider() async {
    return await TodoProvider.create(storage);
  }

  test('Add task (limit 10)', () async {
    final prov = await createProvider();

    for (int i = 0; i < 10; i++) {
      prov.addTask('T$i');
    }

    expect(prov.current.tasks.length, 10);

    prov.addTask('Extra'); // deve ignorar
    expect(prov.current.tasks.length, 10);
  });

  test('Toggle done', () async {
    final prov = await createProvider();
    prov.addTask('Teste');

    final task = prov.current.tasks.first;
    prov.toggleDone(task.id, true);

    expect(prov.current.tasks.first.done, true);
  });

  test('Edit task', () async {
    final prov = await createProvider();

    prov.addTask('Velho');
    final id = prov.current.tasks.first.id;

    prov.editTask(id, 'Novo');
    expect(prov.current.tasks.first.title, 'Novo');
  });

  test('Delete task', () async {
    final prov = await createProvider();

    prov.addTask('A');
    prov.addTask('B');

    prov.deleteTask(prov.current.tasks.first.id);

    expect(prov.current.tasks.length, 1);
  });

  test('Save current list (limit 3)', () async {
    final prov = await createProvider();

    expect(prov.savedLists.length, 0);

    prov.saveCurrentAs('L1');
    prov.saveCurrentAs('L2');
    prov.saveCurrentAs('L3');

    expect(prov.savedLists.length, 3);

    final fail = prov.saveCurrentAs('L4'); // deve retornar false
    expect(fail, false);
  });

  test('Switch between saved lists', () async {
    final prov = await createProvider();

    // Lista A
    prov.addTask('A1');
    prov.saveCurrentAs('Lista A');

    // Nova lista vazia
    prov.createNewEmptyList('Lista B');
    prov.addTask('B1');
    prov.saveCurrentAs('Lista B');

    final idA = prov.savedLists.first.id;
    final idB = prov.savedLists.last.id;

    prov.switchToSavedList(idA);
    expect(prov.current.name, 'Lista A');
    expect(prov.current.tasks.first.title, 'A1');

    prov.switchToSavedList(idB);
    expect(prov.current.name, 'Lista B');
    expect(prov.current.tasks.first.title, 'B1');
  });

  test('Delete saved list', () async {
    final prov = await createProvider();

    prov.saveCurrentAs('Test List');
    expect(prov.savedLists.length, 1);

    final id = prov.savedLists.first.id;
    prov.deleteSavedList(id);

    expect(prov.savedLists.isEmpty, true);
  });
}
