import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TaskFilter { all, active, completed }

class Task {
  Task({required this.title, this.completed = false});

  final String title;
  bool completed;
}

class TaskList extends StateNotifier<List<Task>> {
  TaskList() : super([]);

  void addTask(String title) {
    state = [...state, Task(title: title)];
  }

  void toggleTask(Task task) {
    task.completed = !task.completed;
    state = [...state];
  }
}

class TaskListFilter extends StateNotifier<TaskFilter> {
  TaskListFilter() : super(TaskFilter.all);

  void setFilter(TaskFilter filter) {
    state = filter;
  }
}
