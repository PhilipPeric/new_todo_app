import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_todo_app/presentation/screens/home.dart';
import 'package:new_todo_app/presentation/widgets/form.dart';

import 'app_config.dart';

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  const MyApp(this.appConfig, {Key? key} ) : super(key: key);

  Widget _flavorBanner(Widget child) {
    return Banner(
      location: BannerLocation.topEnd,
      message: appConfig.flavor,
      color: appConfig.flavor == 'dev'
          ? Colors.red.withOpacity(0.6)
          : Colors.green.withOpacity(0.6),
      textStyle: const TextStyle(
          fontWeight: FontWeight.w700, fontSize: 14.0, letterSpacing: 1.0),
      textDirection: TextDirection.ltr,
      child: child,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => _flavorBanner(const Home()),
        '/newTask': (context) => _flavorBanner(FormExample(
          todo: null,
        )),
      },
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
    );
  }
}