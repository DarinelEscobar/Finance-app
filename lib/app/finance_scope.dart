import 'package:flutter/widgets.dart';

import '../data/local/database/app_database.dart';
import '../data/local/repositories/finance_repository.dart';

class FinanceScope extends InheritedWidget {
  const FinanceScope({
    required this.database,
    required this.repository,
    required super.child,
    super.key,
  });

  final AppDatabase database;
  final FinanceRepository repository;

  static FinanceScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FinanceScope>();
    assert(scope != null, 'FinanceScope was not found in the widget tree.');
    return scope!;
  }

  @override
  bool updateShouldNotify(FinanceScope oldWidget) {
    return database != oldWidget.database || repository != oldWidget.repository;
  }
}
