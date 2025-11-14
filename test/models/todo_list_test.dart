import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/tark.dart';
import 'package:todo_app/models/todo_list.dart';

void main() {
  test('TodoList serialize/deserialize', () {
    final list = TodoList(
      id: 'abc',
      name: 'Minha lista',
      tasks: [
        Task(id: '1', title: 'A'),
        Task(id: '2', title: 'B', done: true),
      ],
    );

    final json = list.toJson();
    final newList = TodoList.fromJson(json);

    expect(newList.id, list.id);
    expect(newList.name, list.name);
    expect(newList.tasks.length, 2);
    expect(newList.tasks[1].done, true);
  });
}
