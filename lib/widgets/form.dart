import 'package:flutter/material.dart';
import 'package:new_todo_app/model/todo.dart';
import 'package:intl/intl.dart';

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  bool isChecked = false;
  String dropdownValue = 'Нет';
  TextEditingController titleController = TextEditingController();

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
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: titleController.text,
          date: selectedDate != null
              ? DateFormat("dd MMMM yyy").format(selectedDate!)
              : "",
          isDone: false,
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
                              ? DateFormat("dd MMMM yyy").format(selectedDate!)
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
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        size: 20.0,
                        color: const Color(0xFFFF3B30),
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        'Удалить',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: const Color(0xFFFF3B30),
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
