import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_app/data/local/database/app_database.dart';
import 'package:finance_app/data/local/repositories/finance_repository.dart';
import 'package:finance_app/domain/services/finance_types.dart';
import 'package:finance_app/domain/services/transaction_service.dart';

void main() {
  late AppDatabase database;
  late FinanceRepository repository;
  late TransactionService transactionService;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = FinanceRepository(database);
    transactionService = TransactionService(database);
  });

  tearDown(() async {
    await database.closeDatabase();
  });

  test(
    'account setup creates local user settings source and categories',
    () async {
      await repository.saveAccountSetup(
        const AccountSetupDraft(
          currencyCode: 'usd',
          accountName: 'Cash',
          sourceType: PaymentSourceType.cash,
          openingBalanceMinor: 125000,
          providerLabel: 'Cash',
          monthlyIncomeEstimateMinor: 250000,
        ),
      );

      final user = await repository.getGuestUser();
      expect(user, isNotNull);
      expect(await repository.isSetupComplete(), isTrue);

      final sources = await repository.listActivePaymentSources(user!.id);
      expect(sources, hasLength(1));
      expect(sources.single.currencyCode, 'USD');
      expect(sources.single.openingBalanceMinor, 125000);
      expect(sources.single.currentBalanceMinor, 125000);

      final expenseCategories = await repository.listActiveCategories(
        user.id,
        type: CategoryType.expense,
      );
      final incomeCategories = await repository.listActiveCategories(
        user.id,
        type: CategoryType.income,
      );

      expect(
        expenseCategories.map((category) => category.name),
        contains('Food'),
      );
      expect(
        incomeCategories.map((category) => category.name),
        contains('Salary'),
      );
    },
  );

  test(
    'income expense transfer and soft delete keep balances correct',
    () async {
      await repository.saveAccountSetup(
        const AccountSetupDraft(
          currencyCode: 'USD',
          accountName: 'Cash',
          sourceType: PaymentSourceType.cash,
          openingBalanceMinor: 100000,
        ),
      );

      final user = (await repository.getGuestUser())!;
      final source = (await repository.listActivePaymentSources(
        user.id,
      )).single;
      final food = (await repository.listActiveCategories(
        user.id,
        type: CategoryType.expense,
      )).firstWhere((category) => category.name == 'Food');
      final salary = (await repository.listActiveCategories(
        user.id,
        type: CategoryType.income,
      )).firstWhere((category) => category.name == 'Salary');

      final savingsId = await database
          .into(database.paymentSources)
          .insert(
            PaymentSourcesCompanion.insert(
              userId: user.id,
              name: 'Savings',
              type: PaymentSourceType.savings.storageValue,
              currencyCode: 'USD',
              openingBalanceMinor: const Value(0),
              currentBalanceMinor: const Value(0),
            ),
          );

      await transactionService.createTransaction(
        FinanceTransactionDraft(
          userId: user.id,
          type: TransactionType.income,
          amountMinor: 50000,
          currencyCode: 'USD',
          occurredAt: DateTime(2026, 4, 24),
          paymentSourceId: source.id,
          categoryId: salary.id,
        ),
      );
      await transactionService.createTransaction(
        FinanceTransactionDraft(
          userId: user.id,
          type: TransactionType.expense,
          amountMinor: 12000,
          currencyCode: 'USD',
          occurredAt: DateTime(2026, 4, 24),
          paymentSourceId: source.id,
          categoryId: food.id,
        ),
      );
      final transferId = await transactionService.createTransaction(
        FinanceTransactionDraft(
          userId: user.id,
          type: TransactionType.transfer,
          amountMinor: 25000,
          currencyCode: 'USD',
          occurredAt: DateTime(2026, 4, 24),
          paymentSourceId: source.id,
          destinationSourceId: savingsId,
        ),
      );

      var cash = await (database.select(
        database.paymentSources,
      )..where((row) => row.id.equals(source.id))).getSingle();
      var savings = await (database.select(
        database.paymentSources,
      )..where((row) => row.id.equals(savingsId))).getSingle();
      expect(cash.currentBalanceMinor, 113000);
      expect(savings.currentBalanceMinor, 25000);

      await transactionService.softDeleteTransaction(transferId);

      cash = await (database.select(
        database.paymentSources,
      )..where((row) => row.id.equals(source.id))).getSingle();
      savings = await (database.select(
        database.paymentSources,
      )..where((row) => row.id.equals(savingsId))).getSingle();
      expect(cash.currentBalanceMinor, 138000);
      expect(savings.currentBalanceMinor, 0);
    },
  );
}
