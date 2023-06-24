import 'package:flutter/material.dart';
import '../../domain/model/todo.dart';
import '../widgets/form.dart';

class SecondScreen extends StatelessWidget {
  final ToDo? todo;

  const SecondScreen(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return FormExample(todo: todo);
  }
}
