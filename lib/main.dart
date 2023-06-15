import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_todo_app/widgets/form.dart';
import './screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/newTask': (context) => const FormExample(),
      },
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
    );
  }
}
