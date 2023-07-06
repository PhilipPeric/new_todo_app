import '../../domain/model/todo.dart';

abstract class IRemoteDataSource {
  Future<List<ToDo>> listTodos();

  Future<ToDo?> updateTodoCompletion({required ToDo todo});

  Future<ToDo?> updateTodo({required ToDo todo});

  Future<ToDo?> createTodo({required ToDo todo});

  Future<bool> deleteTodo({required String id});

  Future<ToDo?> getTodo({required int id});

  int getRevision();

  Future<List<ToDo>> patchTodos(List<ToDo> todos, int revision);
}
