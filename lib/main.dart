import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_todo_app/presentation/widgets/form.dart';
import './presentation/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/newTask': (context) => FormExample(
              todo: null,
            ),
      },
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
    );
  }
}
