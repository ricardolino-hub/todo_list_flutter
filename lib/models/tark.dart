class Task {
  String id;
  String title;
  bool done;

  Task({
    required this.id,
    required this.title,
    this.done = false,
  });

  factory Task.fromJson(Map<String, dynamic> j) => Task(
    id: j['id'] as String,
    title: j['title'] as String,
    done: j['done'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'done': done,
  };
}
