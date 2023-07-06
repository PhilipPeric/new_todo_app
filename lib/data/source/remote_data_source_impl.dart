import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:http/http.dart' as http;
import 'package:new_todo_app/data/source/remote_data_source.dart';

import '../../../../env/env.dart';
import '../../domain/model/todo.dart';

final log = Logger('ExampleLogger');

class RemoteDataSource implements IRemoteDataSource {
  int? revision;

  @override
  Future<List<ToDo>> listTodos() async {
    final List<ToDo> todosList = [];

    try {
      final http.Response response = await http.get(
        Uri.parse('${Env.todoServiceUrl}list'),
        headers: {
          'Authorization': 'Bearer ${Env.token}',
        },
      );
      switch (response.statusCode) {
        case 200:
          final result = json.decode(response.body);
          for (final Map<String, dynamic> todo in result['list']) {
            todosList.add(ToDo.fromJson(todo));
          }
          revision = result['revision'];
        default:
          throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      log.severe('List: $e');
    }

    return todosList;
  }

  @override
  Future<ToDo?> updateTodoCompletion({required ToDo todo}) async {
    try {
      todo.isDone = !todo.isDone;
      final http.Response response = await http.put(
        Uri.parse('${Env.todoServiceUrl}list/${todo.id}'),
        headers: {
          'Authorization': 'Bearer ${Env.token}',
          'X-Last-Known-Revision': revision.toString(),
        },
        body: jsonEncode({
          'element': todo.toJson(),
        }),
      );

      switch (response.statusCode) {
        case 200:
          final result = json.decode(response.body);
          revision = result['revision'];
          final ToDo todo = ToDo.fromJson(result['element']);
          return todo;
        default:
          throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      log.severe('Update: $e');
    }
    return null;
  }

  @override
  Future<ToDo?> updateTodo({required ToDo todo}) async {
    try {
      final String body = jsonEncode({
        'element': todo.toJson(),
      });
      final http.Response response = await http.put(
        Uri.parse('${Env.todoServiceUrl}list/${todo.id}'),
        headers: {
          'Authorization': 'Bearer ${Env.token}',
          'X-Last-Known-Revision': revision.toString(),
        },
        body: body,
      );

      switch (response.statusCode) {
        case 200:
          final result = json.decode(response.body);
          revision = result['revision'];
          final ToDo todo = ToDo.fromJson(result['element']);
          return todo;
        default:
          throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      log.severe('Update: $e');
    }
    return null;
  }

  @override
  Future<ToDo?> createTodo({required ToDo todo}) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('${Env.todoServiceUrl}list'),
        headers: {
          'Authorization': 'Bearer ${Env.token}',
          'X-Last-Known-Revision': revision.toString(),
        },
        body: jsonEncode({
          'element': todo.toJson(),
        }),
      );

      switch (response.statusCode) {
        case 200:
          final result = json.decode(response.body);
          revision = result['revision'];
          final ToDo todo = ToDo.fromJson(result['element']);
          return todo;
        default:
          throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      log.severe('Create: $e');
    }
    return null;
  }

  @override
  Future<bool> deleteTodo({required String id}) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse('${Env.todoServiceUrl}list/$id'),
        headers: {
          'Authorization': 'Bearer ${Env.token}',
          'X-Last-Known-Revision': revision.toString(),
        },
      );

      switch (response.statusCode) {
        case 200:
          final result = json.decode(response.body);
          revision = result['revision'];
          return true;
        default:
          throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      log.severe('Delete: $e');
    }
    return false;
  }

  @override
  Future<ToDo?> getTodo({required int id}) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('${Env.todoServiceUrl}list/$id'),
        headers: {
          'Authorization': 'Bearer ${Env.token}',
        },
      );
      switch (response.statusCode) {
        case 200:
          final todoJson = json.decode(response.body);
          revision = todoJson['revision'];
          final ToDo todo = ToDo.fromJson(todoJson);
          return todo;
        default:
          throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      log.severe('Get: $e');
    }

    return null;
  }

  @override
  Future<List<ToDo>> patchTodos(List<ToDo> todos, int revision) async {
    final List<ToDo> todosList = [];

    try {
      final http.Response response = await http.patch(
        Uri.parse('${Env.todoServiceUrl}list/'),
        headers: {
          'Authorization': 'Bearer ${Env.token}',
        },
        body: jsonEncode({
          'list': jsonEncode(todos).toString(),
        }),
      );
      switch (response.statusCode) {
        case 200:
          final result = json.decode(response.body);
          for (final Map<String, dynamic> todo in result['list']) {
            todosList.add(ToDo.fromJson(todo));
          }
          revision = result['revision'];
        default:
          throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      log.severe('Patch: $e');
    }

    return todosList;
  }

  @override
  int getRevision() {
    return revision ?? -1;
  }
}
