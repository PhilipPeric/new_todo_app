import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'app_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  AppConfig prodAppConfig = AppConfig(appName: 'Todo app Prod', flavor: 'prod');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(prodAppConfig));
}
