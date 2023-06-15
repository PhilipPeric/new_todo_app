import 'package:flutter/material.dart';

import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: const Color(0xFF34C759),
        child: const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.check, color: Colors.white),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        color: const Color(0xFFFF3B30),
        child: const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white),
            ],
          ),
        ),
      ),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          onToDoChanged(todo);
        } else {
          onDeleteItem(todo.id);
        }
      },
      child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color(0xFF34C759),
          title: Text(
            todo.isUrgent
                ? '❗️${todo.todoText!}'
                : todo.isUnimportant
                    ? '▼ ${todo.todoText!}'
                    : todo.todoText!,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              fontSize: 16,
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          secondary: const Icon(
            Icons.info,
          ),
          subtitle: Text(todo.date ?? '',
              style: const TextStyle(
                  color: Colors.grey, fontSize: 14, height: 14 / 20)),
          value: todo.isDone,
          onChanged: (bool? value) {
            onToDoChanged(todo);
          }),
    );
  }
}
