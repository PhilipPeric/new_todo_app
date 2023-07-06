import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:new_todo_app/data/repository/todo_service_impl.dart';
import 'package:new_todo_app/domain/model/todo.dart';
import 'package:uuid/uuid.dart';

import '../mocks/repository.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  var remoteMock = MockIRemoteDataSource();
  var localMock = MockILocalDataSource();
  var todoSvc = TodoService(remoteMock, localMock);
  final todoFromRemote = ToDo(
    DateTime.now(),
    DateTime.now(),
    DateTime.now().toString(),
    id: const Uuid().v4(),
    deadline: null,
    todoText: 'Remote',
  );

  final todoFromLocal = ToDo(
    DateTime.now(),
    DateTime.now(),
    DateTime.now().toString(),
    id: const Uuid().v4(),
    deadline: null,
    todoText: 'Local',
  );

  var remoteRevision = 1;
  var localRevision = 0;

  setUp(() {
    // Preparing for getTodos
    when(remoteMock.listTodos()).thenAnswer((_) async => [todoFromRemote]);
    when(localMock.getTodos()).thenAnswer((_) async => [todoFromLocal]);
    // Revision from local cache is lower - so we expect to get todo from remote
    // data source.
    when(localMock.getRevision()).thenAnswer((_) async => localRevision);
    when(remoteMock.getRevision()).thenAnswer((_) => remoteRevision);

    // Preparing for saveTodo
    when(remoteMock.createTodo(todo: todoFromRemote))
        .thenAnswer((_) async => todoFromRemote);
    when(localMock.saveTodo(todoFromRemote, remoteRevision))
        .thenAnswer((_) async => todoFromRemote);

    // Preparing for update
    when(remoteMock.updateTodo(todo: todoFromRemote))
        .thenAnswer((_) async => todoFromRemote);
    when(localMock.updateTodo(todoFromRemote, remoteRevision))
        .thenAnswer((_) async => todoFromRemote);
  });

  test(
      'Network is available, todos from data source with higher revision are returned.',
      () async {
    final actual = await todoSvc.getTodos();
    expect([todoFromRemote], actual);
    // Check that updateTodos on local data source has been called.
    verify(localMock.updateTodos([todoFromRemote], 1));
  });

  test(
      'Network is available, remote todo creation + saving to local with revision from remote, if it is bigger.',
      () async {
    final actual = await todoSvc.saveTodo(todoFromRemote);
    expect(todoFromRemote, actual);
    // Check that updateTodos on local data source has been called.
    verify(localMock.saveTodo(todoFromRemote, remoteRevision));
  });

  test(
      'Network is available, remote todo update + updating local with revision from remote, if it is bigger.',
      () async {
    final actual = await todoSvc.updateTodo(todoFromRemote);
    expect(todoFromRemote, actual);
    // Check that updateTodos on local data source has been called.
    verify(localMock.updateTodo(todoFromRemote, remoteRevision));
  });
}
