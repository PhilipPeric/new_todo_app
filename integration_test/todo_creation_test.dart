import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:new_todo_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'todo creation test',
    () {
      testWidgets(
        'tap on button for todo creation, expect form page to open and СОХРАНИТЬ button to appear',
        (tester) async {
          app.main();

          await tester.pumpAndSettle();
          expect(find.text('Мои дела'), findsWidgets);

          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();

          // СОХРАНИТЬ button is on form page, so we checked functionality of routing to task creation
          expect(find.text('СОХРАНИТЬ'), findsWidgets);
        },
      );
    },
  );
}
