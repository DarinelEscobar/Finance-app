// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_app/main.dart';

void main() {
  testWidgets('renders the finance dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceApp());

    expect(find.text('Total balance'), findsOneWidget);
    expect(find.text('Recent transactions'), findsOneWidget);
    expect(find.text('Add transaction'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
