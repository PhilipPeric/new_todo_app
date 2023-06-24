import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'TOKEN', obfuscate: true)
  static String token = _Env.token;
  @EnviedField(varName: 'TODO_SERVICE_URL')
  static const String todoServiceUrl = _Env.todoServiceUrl;
}
