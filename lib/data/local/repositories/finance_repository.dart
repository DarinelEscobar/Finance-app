import 'package:drift/drift.dart';

import '../../../domain/services/default_categories.dart';
import '../../../domain/services/finance_types.dart';
import '../database/app_database.dart';

class AccountSetupDraft {
  const AccountSetupDraft({
    required this.currencyCode,
    required this.accountName,
    required this.sourceType,
    required this.openingBalanceMinor,
    this.providerLabel,
    this.monthlyIncomeEstimateMinor,
    this.budgetMode = 'monthly',
  });

  final String currencyCode;
  final String accountName;
  final PaymentSourceType sourceType;
  final int openingBalanceMinor;
  final String? providerLabel;
  final int? monthlyIncomeEstimateMinor;
  final String budgetMode;
}

class FinanceRepository {
  FinanceRepository(this.database);

  final AppDatabase database;

  Future<UserRecord?> getGuestUser() {
    final query = database.select(database.users)
      ..where((user) => user.isGuest.equals(true))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<int> ensureGuestUser() async {
    final existing = await getGuestUser();
    if (existing != null) {
      return existing.id;
    }

    final now = DateTime.now();
    return database
        .into(database.users)
        .insert(
          UsersCompanion.insert(
            isGuest: const Value(true),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<bool> hasLocalUser() async =>
      getGuestUser().then((user) => user != null);

  Future<bool> isSetupComplete() async {
    final user = await getGuestUser();
    if (user == null) {
      return false;
    }

    final settings =
        await (database.select(database.userSettings)
              ..where((row) => row.userId.equals(user.id))
              ..limit(1))
            .getSingleOrNull();
    if (settings == null) {
      return false;
    }

    final source =
        await (database.select(database.paymentSources)
              ..where(
                (row) => row.userId.equals(user.id) & row.isActive.equals(true),
              )
              ..limit(1))
            .getSingleOrNull();
    return source != null;
  }

  Future<void> seedDefaultCategories(int userId) async {
    final now = DateTime.now();
    for (final definition in defaultCategoryDefinitions) {
      final existing =
          await (database.select(database.categories)
                ..where(
                  (row) =>
                      row.userId.equals(userId) &
                      row.name.equals(definition.name) &
                      row.type.equals(definition.type.storageValue),
                )
                ..limit(1))
              .getSingleOrNull();

      if (existing == null) {
        await database
            .into(database.categories)
            .insert(
              CategoriesCompanion.insert(
                userId: userId,
                name: definition.name,
                type: definition.type.storageValue,
                icon: Value(definition.icon),
                color: Value(definition.color),
                isSystem: const Value(true),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      }
    }
  }

  Future<void> saveAccountSetup(AccountSetupDraft draft) async {
    final normalizedCurrency = draft.currencyCode.trim().toUpperCase();
    if (normalizedCurrency.length != 3) {
      throw ArgumentError.value(draft.currencyCode, 'currencyCode');
    }
    if (draft.accountName.trim().isEmpty) {
      throw ArgumentError.value(draft.accountName, 'accountName');
    }

    await database.transaction(() async {
      final userId = await ensureGuestUser();
      await seedDefaultCategories(userId);
      final now = DateTime.now();

      final existingSettings =
          await (database.select(database.userSettings)
                ..where((row) => row.userId.equals(userId))
                ..limit(1))
              .getSingleOrNull();

      if (existingSettings == null) {
        await database
            .into(database.userSettings)
            .insert(
              UserSettingsCompanion.insert(
                userId: userId,
                currencyCode: normalizedCurrency,
                budgetMode: Value(draft.budgetMode),
                monthlyIncomeEstimateMinor: Value(
                  draft.monthlyIncomeEstimateMinor,
                ),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      } else {
        await (database.update(
          database.userSettings,
        )..where((row) => row.id.equals(existingSettings.id))).write(
          UserSettingsCompanion(
            currencyCode: Value(normalizedCurrency),
            budgetMode: Value(draft.budgetMode),
            monthlyIncomeEstimateMinor: Value(draft.monthlyIncomeEstimateMinor),
            updatedAt: Value(now),
          ),
        );
      }

      final hasAccount =
          await (database.select(database.paymentSources)
                ..where((row) => row.userId.equals(userId))
                ..limit(1))
              .getSingleOrNull();

      if (hasAccount == null) {
        await database
            .into(database.paymentSources)
            .insert(
              PaymentSourcesCompanion.insert(
                userId: userId,
                name: draft.accountName.trim(),
                type: draft.sourceType.storageValue,
                currencyCode: normalizedCurrency,
                providerLabel: Value(_blankToNull(draft.providerLabel)),
                openingBalanceMinor: Value(draft.openingBalanceMinor),
                currentBalanceMinor: Value(draft.openingBalanceMinor),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      }
    });
  }

  Future<List<CategoryRecord>> listActiveCategories(
    int userId, {
    CategoryType? type,
  }) {
    final query = database.select(database.categories)
      ..where(
        (row) =>
            row.userId.equals(userId) &
            row.isArchived.equals(false) &
            row.deletedAt.isNull(),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.type),
        (row) => OrderingTerm.asc(row.name),
      ]);

    if (type != null) {
      query.where((row) => row.type.equals(type.storageValue));
    }

    return query.get();
  }

  Future<List<PaymentSourceRecord>> listActivePaymentSources(int userId) {
    final query = database.select(database.paymentSources)
      ..where((row) => row.userId.equals(userId) & row.isActive.equals(true))
      ..orderBy([
        (row) => OrderingTerm.asc(row.displayOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.get();
  }
}

String? _blankToNull(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return normalized;
}
