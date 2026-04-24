import 'package:flutter/material.dart';

import '../data/local/database/app_database.dart';
import '../data/local/repositories/finance_repository.dart';
import 'app_theme.dart';
import 'finance_scope.dart';
import 'startup_gate.dart';

class FinanceApp extends StatefulWidget {
  const FinanceApp({this.database, super.key});

  final AppDatabase? database;

  @override
  State<FinanceApp> createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  late final AppDatabase _database = widget.database ?? AppDatabase();
  late final FinanceRepository _repository = FinanceRepository(_database);
  late final bool _ownsDatabase = widget.database == null;

  @override
  void dispose() {
    if (_ownsDatabase) {
      _database.closeDatabase();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinanceScope(
      database: _database,
      repository: _repository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance',
        theme: buildFinanceTheme(),
        home: const StartupGate(),
      ),
    );
  }
}
