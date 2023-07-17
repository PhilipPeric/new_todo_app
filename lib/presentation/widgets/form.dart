import 'package:flutter/material.dart';
import 'package:new_todo_app/domain/model/todo.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

//ignore: must_be_immutable
class FormExample extends StatefulWidget {
  ToDo? todo;

  FormExample({super.key, required this.todo});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  bool isChecked = false;
  String dropdownValue = 'Нет';
  TextEditingController titleController = TextEditingController();
  DateTime createdAt = DateTime.now();
  DateTime changedAt = DateTime.now();
  String lastUpdatedBy = DateTime.now().toString();
  String id = uuid.v4();
  bool isDone = false;

  void checkboxCallback(bool? checkboxState) {
    setState(() {
      isChecked = checkboxState ?? true;
    });
    if (isChecked) {
      _selectDate(context);
    } else {
      setState(() {
        selectedDate = null;
      });
    }
  }

  // get the text in the TextField and send it back to the FirstScreen
  void _sendDataBack(BuildContext context) {
    Navigator.pop(
        context,
        ToDo(
          createdAt,
          changedAt,
          lastUpdatedBy,
          id: id,
          todoText: titleController.text,
          deadline: selectedDate,
          isDone: isDone,
          isUnimportant: dropdownValue == 'Низкий' ? true : false,
          isUrgent: dropdownValue == '!! Высокий' ? true : false,
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    } else {
      setState(() {
        isChecked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todo != null) {
      if (widget.todo!.deadline != null) {
        selectedDate = widget.todo?.deadline;
        isChecked = true;
      }

      if (widget.todo!.todoText != null) {
        titleController.text = widget.todo!.todoText!;
      }
      if (widget.todo!.isUrgent) {
        dropdownValue = '!! Высокий';
      }
      if (widget.todo!.isUnimportant) {
        dropdownValue = 'Низкий';
      }
      if (widget.todo?.createdAt != null) {
        createdAt = widget.todo!.createdAt;
      }
      if (widget.todo?.changedAt != null) {
        changedAt = widget.todo!.changedAt;
      }
      if (widget.todo!.lastUpdatedBy != null) {
        lastUpdatedBy = widget.todo!.lastUpdatedBy!;
      }
      if (widget.todo?.id != null) {
        id = widget.todo!.id!;
      }
      isDone = widget.todo!.isDone;

      widget.todo = null;
    }

    return Scaffold(
        backgroundColor: const Color(0xFFE5E5E5),
        appBar: AppBar(
          leading: IconButton(
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close)),
          backgroundColor: const Color(0xFFE5E5E5),
          elevation: 0,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 14),
              ),
              onPressed: () {
                _sendDataBack(context);
              },
              child: const Text('СОХРАНИТЬ'),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Material(
                  elevation: 2,
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Что надо сделать...',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Важность',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    DropdownButtonFormField(
                      value: dropdownValue,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      iconSize: 0.0,
                      items: [
                        'Нет',
                        'Низкий',
                        '!! Высокий',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          alignment: AlignmentDirectional.centerStart,
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    value == '!! Высокий' ? Colors.red : null),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Сделать до',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          selectedDate != null
                              ? DateFormat('dd MMMM yyy').format(selectedDate!)
                              : '',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    Switch(
                      value: isChecked,
                      onChanged: checkboxCallback,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedDate = null;
                      isChecked = false;
                      titleController.text = '';
                      dropdownValue = 'Нет';
                    });
                  },
                  child: const Row(
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        size: 20.0,
                        color: Color(0xFFFF3B30),
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        'Удалить',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFFFF3B30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
