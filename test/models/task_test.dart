import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/tark.dart';

void main() {
  test('Task serialization and deserialization', () {
    final task = Task(id: '1', title: 'Teste', done: false);

    final json = task.toJson();
    final newTask = Task.fromJson(json);

    expect(newTask.id, task.id);
    expect(newTask.title, task.title);
    expect(newTask.done, task.done);
  });
}
