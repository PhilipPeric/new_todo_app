import 'package:new_todo_app/domain/model/todo.dart';

abstract class ITodosRepository {
  Future<List<ToDo>> getTodos();

  Future<ToDo?> saveTodo(ToDo todo);

  Future<void> deleteTodo(ToDo todo);

  Future<ToDo?> updateTodo(ToDo todo);
}
