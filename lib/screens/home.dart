import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../widgets/todo_item.dart';
import 'new_task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todosList = [];
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  final scrollController = ScrollController();
  int _doneTasksCounter = 0;
  bool isFiltered = false;

  @override
  void initState() {
    _foundToDo = todosList;
    for (var i = 0; i < _foundToDo.length; i++) {
      if (_foundToDo[i].isDone) {
        _doneTasksCounter++;
      }
    }
    super.initState();
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
      body: CustomScrollView(
          slivers: _foundToDo.isNotEmpty
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
                            children: <Widget>[
                              for (ToDo todoo in _foundToDo)
                                ToDoItem(
                                  todo: todoo,
                                  onToDoChanged: _handleToDoChange,
                                  onDeleteItem: _deleteToDoItem,
                                ),
                            ], // Set this
                          )
                        ],
                      ),
                    ),
                  ),
                ]
              : <Widget>[_buildSliverAppBar()]),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      if (todo.isDone) {
        _doneTasksCounter++;
      } else {
        _doneTasksCounter--;
      }
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      for (var i = 0; i < _foundToDo.length; i++) {
        if (_foundToDo[i].id == id) {
          if (_foundToDo[i].isDone) {
            _doneTasksCounter--;
            break;
          }
        }
      }
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SecondScreen(),
        ));

    _addToDoItem(result);
  }

  void _addToDoItem(ToDo toDo) {
    setState(() {
      todosList.add(toDo);
    });
    _todoController.clear();
  }

  void _runFilter() {
    setState(() {
      isFiltered = !isFiltered;
      if (isFiltered) {
        _foundToDo = todosList.where((item) => !item.isDone).toList();
      } else {
        _foundToDo = todosList;
      }
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
              Container(
                child: const Text(
                  'Мои дела',
                  style: TextStyle(
                      color: Colors.black, fontSize: 32, height: 38 / 32),
                ),
              ),
              Container(
                child: Text(
                  'Выполнено - $_doneTasksCounter',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    height: 14 / 20,
                  ),
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
