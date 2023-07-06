// ignore_for_file: unused_import

import 'package:mockito/annotations.dart';
import 'package:new_todo_app/data/source/local_data_source.dart';
import 'package:new_todo_app/data/source/remote_data_source.dart';
import 'repository.mocks.dart';

@GenerateMocks([IRemoteDataSource, ILocalDataSource])
void main() {}
