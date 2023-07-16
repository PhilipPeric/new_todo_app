import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'app.dart';
import 'app_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  AppConfig devAppConfig = AppConfig(appName: 'Todo app dev', flavor: 'dev');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(devAppConfig));
}
