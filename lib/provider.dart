import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core.dart';

final taskListProvider =
    StateNotifierProvider<TaskList, List<Task>>((ref) => TaskList());
final taskListFilterProvider =
    StateNotifierProvider<TaskListFilter, TaskFilter>(
        (ref) => TaskListFilter());
