// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

class _Env {
  static const List<int> _enviedkeytoken = [
    3300547954,
    1500113492,
    469373404,
    280394994,
    3215165216,
    1000627741,
    1535046818,
    2062144043,
    309316127,
    30855868
  ];
  static const List<int> _envieddatatoken = [
    3300547842,
    1500113461,
    469373358,
    280394899,
    3215165264,
    1000627823,
    1535046851,
    2062144083,
    309316214,
    30855887
  ];
  static final String token = String.fromCharCodes(
    List.generate(_envieddatatoken.length, (i) => i, growable: false)
        .map((i) => _envieddatatoken[i] ^ _enviedkeytoken[i])
        .toList(growable: false),
  );
  static const String todoServiceUrl = 'https://beta.mrdekk.ru/todobackend/';
}
