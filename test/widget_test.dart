import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_app/app/finance_app.dart';
import 'package:finance_app/data/local/database/app_database.dart';
import 'package:finance_app/data/local/repositories/finance_repository.dart';
import 'package:finance_app/domain/services/finance_types.dart';

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

    expect(find.text('Master your money, effortlessly.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });

  testWidgets('onboarding CTA creates guest user and opens setup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(FinanceApp(database: database));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Add Account'), findsOneWidget);

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

    expect(find.text('Add Account'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_rounded), findsNothing);
  });

  testWidgets('account setup validates required account name', (
    WidgetTester tester,
  ) async {
    final repository = FinanceRepository(database);
    await repository.ensureGuestUser();

    await tester.pumpWidget(FinanceApp(database: database));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Account name is required'), findsOneWidget);
    expect(await repository.isSetupComplete(), isFalse);
  });

  testWidgets('account setup persists local settings source and categories', (
    WidgetTester tester,
  ) async {
    final repository = FinanceRepository(database);
    await repository.ensureGuestUser();

    await tester.pumpWidget(FinanceApp(database: database));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Main Checking');
    await tester.enterText(find.byType(TextFormField).at(1), '123.45');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Total balance'), findsOneWidget);
    expect(await repository.isSetupComplete(), isTrue);

    final user = (await repository.getGuestUser())!;
    final sources = await repository.listActivePaymentSources(user.id);
    expect(sources, hasLength(1));
    expect(sources.single.name, 'Main Checking');
    expect(sources.single.providerLabel, isNull);
    expect(sources.single.currencyCode, 'USD');
    expect(sources.single.type, 'checking');
    expect(sources.single.currentBalanceMinor, 12345);

    final categories = await repository.listActiveCategories(user.id);
    expect(categories, isNotEmpty);
  });

  testWidgets(
    'temporary dashboard reset clears local data and returns onboarding',
    (WidgetTester tester) async {
      final repository = FinanceRepository(database);
      await repository.saveAccountSetup(
        const AccountSetupDraft(
          currencyCode: 'USD',
          accountName: 'Main Checking',
          sourceType: PaymentSourceType.checking,
          openingBalanceMinor: 5000,
        ),
      );

      await tester.pumpWidget(FinanceApp(database: database));
      await tester.pumpAndSettle();

      expect(find.text('Total balance'), findsOneWidget);
      expect(await repository.isSetupComplete(), isTrue);

      await tester.scrollUntilVisible(
        find.text('Reset local data'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Reset local data'));
      await tester.pumpAndSettle();

      expect(find.text('Reset local data?'), findsOneWidget);
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Master your money, effortlessly.'), findsOneWidget);
      expect(await repository.hasLocalUser(), isFalse);
      expect(await repository.isSetupComplete(), isFalse);
    },
  );
}
