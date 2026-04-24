import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_app/app/finance_app.dart';
import 'package:finance_app/data/local/database/app_database.dart';
import 'package:finance_app/data/local/repositories/finance_repository.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.closeDatabase();
  });

  testWidgets('clean install renders onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(FinanceApp(database: database));
    await tester.pumpAndSettle();

    expect(find.text('Finance'), findsOneWidget);
    expect(find.text('Track your money with clarity.'), findsOneWidget);
    expect(find.text('Start tracking'), findsOneWidget);
    expect(find.text('Continue as guest'), findsOneWidget);
  });

  testWidgets('onboarding CTA creates guest user and opens setup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(FinanceApp(database: database));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start tracking'));
    await tester.pumpAndSettle();

    expect(find.text('Set up your account'), findsOneWidget);

    final repository = FinanceRepository(database);
    expect(await repository.hasLocalUser(), isTrue);
    expect(await repository.isSetupComplete(), isFalse);
  });

  testWidgets('existing guest without setup starts on account setup', (
    WidgetTester tester,
  ) async {
    final repository = FinanceRepository(database);
    await repository.ensureGuestUser();

    await tester.pumpWidget(FinanceApp(database: database));
    await tester.pumpAndSettle();

    expect(find.text('Set up your account'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_rounded), findsNothing);
  });
}
