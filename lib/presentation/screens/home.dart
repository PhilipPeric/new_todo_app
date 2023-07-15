import 'package:flutter/material.dart';

import '../../data/repository/todo_service_impl.dart';
import '../../data/source/local_data_source_impl.dart';
import '../../domain/model/todo.dart';
import '../widgets/todo_item.dart';
import 'new_task.dart';
import '../../data/source/remote_data_source_impl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todosList = [];

  final _todoController = TextEditingController();
  final scrollController = ScrollController();
  int _doneTasksCounter = 0;
  bool isFiltered = false;

  var svc = TodoService(RemoteDataSource(), LocalDataSource());

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _awaitReturnValueFromSecondScreen(context);
        },
        tooltip: 'Create new task',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _getData,
        child: CustomScrollView(
            slivers: todosList.isNotEmpty
                ? <Widget>[
                    _buildSliverAppBar(),
                    SliverToBoxAdapter(
                      child: Card(
                        margin: const EdgeInsets.all(20),
                        elevation: 4,
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            ListView(
                              controller: scrollController,
                              shrinkWrap: true,
                              children: isFiltered
                                  ? <Widget>[
                                      for (ToDo todo in todosList
                                          .where((item) => !item.isDone)
                                          .toList())
                                        ToDoItem(
                                          todo: todo,
                                          onToDoChanged: _handleToDoCheck,
                                          onDeleteItem: _deleteToDoItem,
                                          onEditItem:
                                              _awaitEditedValueFromSecondScreen,
                                        ),
                                    ]
                                  : <Widget>[
                                      for (ToDo todo in todosList)
                                        ToDoItem(
                                          todo: todo,
                                          onToDoChanged: _handleToDoCheck,
                                          onDeleteItem: _deleteToDoItem,
                                          onEditItem:
                                              _awaitEditedValueFromSecondScreen,
                                        ),
                                    ], // Set this
                            )
                          ],
                        ),
                      ),
                    ),
                  ]
                : <Widget>[_buildSliverAppBar()]),
      ),
    );
  }

  Future<void> _getData() async {
    var resp = await svc.getTodos();
    setState(() {
      todosList = resp;
      _doneTasksCounter = 0;
      for (var i = 0; i < todosList.length; i++) {
        if (todosList[i].isDone) {
          _doneTasksCounter++;
        }
      }
    });
  }

  Future<void> _handleToDoCheck(ToDo todo) async {
    todo.isDone = !todo.isDone;
    todo.changedAt = DateTime.now();
    var resp = await svc.updateTodo(todo);
    if (resp != null) {
      setState(() {
        todo = resp;
        if (todo.isDone) {
          _doneTasksCounter++;
        } else {
          _doneTasksCounter--;
        }
      });
    }
  }

  Future<void> _deleteToDoItem(ToDo todo) async {
    await svc.deleteTodo(todo);
    setState(() {
      for (var i = 0; i < todosList.length; i++) {
        if (todosList[i].id == todo.id) {
          if (todosList[i].isDone) {
            _doneTasksCounter--;
          }
          break;
        }
      }
      todosList.removeWhere((item) => item.id == todo.id);
    });
  }

  Future<void> _awaitEditedValueFromSecondScreen(
      BuildContext context, ToDo todo) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(todo),
        ));

    _updateToDo(result);
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SecondScreen(null),
        ));

    _addToDoItem(result);
  }

  Future<void> _addToDoItem(ToDo toDo) async {
    var resp = await svc.saveTodo(toDo);
    if (resp != null) {
      setState(() {
        todosList.add(resp);
      });
    }
    _todoController.clear();
  }

  Future<void> _updateToDo(ToDo todo) async {
    todo.changedAt = DateTime.now();
    var resp = await svc.updateTodo(todo);
    if (resp != null) {
      setState(() {
        for (var i = 0; i < todosList.length; i++) {
          if (todosList[i].id == todo.id) {
            todosList[i] = todo;
            break;
          }
        }
      });
    }
    _todoController.clear();
  }

  void _runFilter() {
    setState(() {
      isFiltered = !isFiltered;
    });
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar.medium(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мои дела',
                style: TextStyle(
                    color: Colors.black, fontSize: 32, height: 38 / 32),
              ),
              Text(
                'Выполнено - $_doneTasksCounter',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  height: 14 / 20,
                ),
              ),
            ],
          ),
          IconButton(
              onPressed: _runFilter,
              icon: isFiltered
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off)),
        ],
      ),
      backgroundColor: const Color(0xFFF7F6F2),
      pinned: true,
      expandedHeight: 160.0,
    );
  }
}
