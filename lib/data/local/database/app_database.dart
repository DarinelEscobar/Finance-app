import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    UserSettings,
    PaymentSources,
    Categories,
    Transactions,
    TransactionSplits,
    Tags,
    TransactionTags,
    Budgets,
    RecurringRules,
    SavingsGoals,
    GoalContributions,
    BillSubscriptions,
    Notifications,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) async => m.createAll());

  Future<void> closeDatabase() => close();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'finance.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
