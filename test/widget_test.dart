// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thirstyseed/iam/application/auth_service.dart';
import 'package:thirstyseed/iam/infrastructure/data_sources/user_data_source.dart';

import 'package:thirstyseed/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Crea un `AuthService` de prueba o usa una implementación simulada
    final authService = AuthService(dataSource: UserDataSource());

    // Proporciona `authService` a `MyApp`
    await tester.pumpWidget(MyApp(authService: authService));

    // Verifica que el contador empiece en 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap al icono '+' y actualiza el frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que el contador ha incrementado
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

