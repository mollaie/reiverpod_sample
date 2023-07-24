import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/provider.dart';

import 'core.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final textEditingControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

final focusNodeProvider = Provider<FocusNode>((ref) {
  return FocusNode();
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = ref.watch(textEditingControllerProvider);
    final focusNode = ref.watch(focusNodeProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Task Manager'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                focusNode: focusNode,
                onSubmitted: (value) {
                  ref.read(taskListProvider.notifier).addTask(value);
                  textController.clear();
                  focusNode.requestFocus();
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: "Enter your task",
                    hintStyle: TextStyle(color: Colors.pink)),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final taskList = ref.watch(taskListProvider);
                final filter = ref.watch(taskListFilterProvider);

                var tasks = taskList.where((task) {
                  switch (filter) {
                    case TaskFilter.all:
                      return true;
                    case TaskFilter.active:
                      return !task.completed;
                    case TaskFilter.completed:
                      return task.completed;
                  }
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      leading: Checkbox(
                        value: task.completed,
                        onChanged: (value) {
                          ref.read(taskListProvider.notifier).toggleTask(task);
                        },
                      ),
                    );
                  },
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final filter = ref.watch(taskListFilterProvider);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: TaskFilter.values.map((f) {
                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: FilterButton(
                        text: f.toString().split('.').last,
                        onPressed: () {
                          ref
                              .read(taskListFilterProvider.notifier)
                              .setFilter(f);
                        },
                        selected: f == filter,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool selected;

  const FilterButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.selected = false});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: selected ? Colors.blue : Colors.grey,
      elevation: 2.0,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
