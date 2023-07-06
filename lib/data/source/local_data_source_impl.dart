import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/model/todo.dart';
import 'local_data_source.dart';

class LocalDataSource implements ILocalDataSource {
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  @override
  Future<void> deleteTodo(String id, int revision) async {
    final List<ToDo> todos = await getTodos();

    todos.removeWhere((item) => item.id == id);

    final sharedPreferences = await _sharedPreferences;
    final jsonTodosListString = jsonEncode(todos).toString();
    sharedPreferences.setString('todos', jsonTodosListString);
    sharedPreferences.setInt('revision', revision);
  }

  @override
  Future<List<ToDo>> getTodos() async {
    final List<ToDo> todosList = [];
    try {
      final sharedPreferences = await _sharedPreferences;
      var jsonTodoListString = sharedPreferences.getString('todos');

      final result = json.decode(jsonTodoListString!);
      for (final Map<String, dynamic> todo in result) {
        todosList.add(ToDo.fromJson(todo));
      }
    } catch (e) {
      return todosList;
    }

    return todosList;
  }

  @override
  Future<void> saveTodo(ToDo todo, int revision) async {
    final todos = await getTodos();
    todos.add(todo);
    final sharedPreferences = await _sharedPreferences;
    final jsonTodosListString = jsonEncode(todos).toString();
    sharedPreferences.setString('todos', jsonTodosListString);
    sharedPreferences.setInt('revision', revision);
  }

  @override
  Future<void> updateTodo(ToDo todo, int revision) async {
    final List<ToDo> todos = await getTodos();

    todos.removeWhere((item) => item.id == todo.id);
    todos.add(todo);

    final sharedPreferences = await _sharedPreferences;
    final jsonTodosListString = jsonEncode(todos).toString();
    sharedPreferences.setString('todos', jsonTodosListString);
    sharedPreferences.setInt('revision', revision);
  }

  @override
  Future<void> updateTodos(List<ToDo> todos, int revision) async {
    final sharedPreferences = await _sharedPreferences;
    final jsonTodosListString = jsonEncode(todos).toString();
    sharedPreferences.setString('todos', jsonTodosListString);
    sharedPreferences.setInt('revision', revision);
  }

  @override
  Future<void> clear() async {
    final sharedPreferences = await _sharedPreferences;

    await sharedPreferences.clear();
  }

  @override
  Future<int> getRevision() async {
    final sharedPreferences = await _sharedPreferences;
    final revision = sharedPreferences.getInt('revision');

    return revision ?? -2;
  }
}
