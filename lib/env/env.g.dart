// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

class _Env {
  static const List<int> _enviedkeytoken = [
    1857583938,
    523022098,
    699981410,
    1672584064,
    1565358649,
    1119723813,
    4084363912,
    1531529925,
    4135468190,
    1093823740
  ];
  static const List<int> _envieddatatoken = [
    1857583922,
    523022195,
    699981328,
    1672584161,
    1565358665,
    1119723863,
    4084364009,
    1531529917,
    4135468279,
    1093823631
  ];
  static final String token = String.fromCharCodes(
    List.generate(_envieddatatoken.length, (i) => i, growable: false)
        .map((i) => _envieddatatoken[i] ^ _enviedkeytoken[i])
        .toList(growable: false),
  );
  static const String todoServiceUrl = 'https://beta.mrdekk.ru/todobackend/';
}
