import '../../domain/model/todo.dart';

abstract class ILocalDataSource {
  Future<List<ToDo>> getTodos();

  Future<void> saveTodo(ToDo todo, int revision);

  Future<void> updateTodo(ToDo todo, int revision);

  Future<void> deleteTodo(String id, int revision);

  Future<void> clear();

  Future<int> getRevision();

  Future<void> updateTodos(List<ToDo> todos, int revision);
}
