import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:new_todo_app/data/source/local_data_source.dart';
import 'package:new_todo_app/data/source/remote_data_source.dart';
import 'package:new_todo_app/domain/repository/todo_service.dart';

import '../../domain/model/todo.dart';

class TodoService implements ITodosRepository {
  TodoService(this.remoteDataSource, this.localDataSource);

  final IRemoteDataSource remoteDataSource;
  final ILocalDataSource localDataSource;

  @override
  Future<List<ToDo>> getTodos() async {
    if (await checkInternetConnectivity()) {
      var data = await remoteDataSource.listTodos();
      final local = await localDataSource.getTodos();
      final localRev = await localDataSource.getRevision();
      final remoteRev = remoteDataSource.getRevision();

      if (remoteRev > localRev) {
        localDataSource.updateTodos(data, remoteRev);
        return data;
      } else {
        data = await remoteDataSource.patchTodos(local, remoteRev);
        localDataSource.updateTodos(data, remoteRev);
        return data;
      }
    } else {
      return await localDataSource.getTodos();
    }
  }

  @override
  Future<ToDo?> saveTodo(ToDo todo) async {
    if (await checkInternetConnectivity()) {
      var data = await remoteDataSource.createTodo(todo: todo);
      await localDataSource.saveTodo(todo, remoteDataSource.getRevision());

      return data;
    } else {
      var curRev = await localDataSource.getRevision();
      curRev++;
      await localDataSource.saveTodo(todo, curRev);
      return todo;
    }
  }

  @override
  Future<void> deleteTodo(ToDo todo) async {
    if (await checkInternetConnectivity()) {
      var data = await remoteDataSource.deleteTodo(id: todo.id!);
      if (data) {
        await localDataSource.deleteTodo(
            todo.id!, remoteDataSource.getRevision());
      }
    } else {
      var curRev = await localDataSource.getRevision();
      curRev++;
      await localDataSource.deleteTodo(todo.id!, curRev);
    }
  }

  @override
  Future<ToDo?> updateTodo(ToDo todo) async {
    if (await checkInternetConnectivity()) {
      var data = await remoteDataSource.updateTodo(todo: todo);
      await localDataSource.updateTodo(
          data ?? todo, remoteDataSource.getRevision());
      return data;
    } else {
      var curRev = await localDataSource.getRevision();
      curRev++;
      await localDataSource.updateTodo(todo, curRev);
      return todo;
    }
  }
}

Future<bool> checkInternetConnectivity() async {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    return true;
  }
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false; // No internet connection
  } else {
    return true; // Connected to the internet
  }
}
