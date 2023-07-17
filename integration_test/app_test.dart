import 'package:flutter/cupertino.dart';
import 'package:new_todo_app/app.dart';
import 'package:new_todo_app/app_config.dart';

void main() async {
  AppConfig devAppConfig = AppConfig(appName: 'Todo app dev', flavor: 'dev');
  runApp(MyApp(devAppConfig));
}
