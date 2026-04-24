import 'package:drift/drift.dart';

import '../../data/local/database/app_database.dart';
import 'finance_types.dart';

class TransactionSplitDraft {
  const TransactionSplitDraft({
    required this.categoryId,
    required this.amountMinor,
    this.note,
  });

  final int categoryId;
  final int amountMinor;
  final String? note;
}

class FinanceTransactionDraft {
  const FinanceTransactionDraft({
    required this.userId,
    required this.type,
    required this.amountMinor,
    required this.currencyCode,
    required this.occurredAt,
    this.paymentSourceId,
    this.destinationSourceId,
    this.categoryId,
    this.note,
    this.status = TransactionStatus.posted,
    this.recurringRuleId,
    this.billSubscriptionId,
    this.createdFrom = 'manual',
    this.splits = const [],
  });

  final int userId;
  final TransactionType type;
  final int amountMinor;
  final String currencyCode;
  final DateTime occurredAt;
  final int? paymentSourceId;
  final int? destinationSourceId;
  final int? categoryId;
  final String? note;
  final TransactionStatus status;
  final int? recurringRuleId;
  final int? billSubscriptionId;
  final String createdFrom;
  final List<TransactionSplitDraft> splits;
}

class TransactionService {
  TransactionService(this.database);

  final AppDatabase database;

  Future<int> createTransaction(FinanceTransactionDraft draft) async {
    _validateDraft(draft);

    return database.transaction(() async {
      final now = DateTime.now();
      final id = await database
          .into(database.transactions)
          .insert(
            TransactionsCompanion.insert(
              userId: draft.userId,
              type: draft.type.storageValue,
              paymentSourceId: Value(draft.paymentSourceId),
              destinationSourceId: Value(draft.destinationSourceId),
              categoryId: Value(draft.categoryId),
              amountMinor: draft.amountMinor,
              currencyCode: draft.currencyCode.trim().toUpperCase(),
              occurredAt: draft.occurredAt,
              note: Value(_blankToNull(draft.note)),
              status: Value(draft.status.storageValue),
              isSplit: Value(draft.splits.isNotEmpty),
              recurringRuleId: Value(draft.recurringRuleId),
              billSubscriptionId: Value(draft.billSubscriptionId),
              createdFrom: Value(draft.createdFrom),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      await _replaceSplits(id, draft.splits);
      if (draft.status == TransactionStatus.posted) {
        await _applyBalanceEffect(draft);
      }
      return id;
    });
  }

  Future<void> updateTransaction(
    int transactionId,
    FinanceTransactionDraft replacement,
  ) async {
    _validateDraft(replacement);

    await database.transaction(() async {
      final existing = await (database.select(
        database.transactions,
      )..where((row) => row.id.equals(transactionId))).getSingle();

      if (existing.deletedAt != null) {
        throw StateError('Cannot update a deleted transaction.');
      }

      if (existing.status == TransactionStatus.posted.storageValue) {
        await _revertBalanceEffect(existing);
      }

      final now = DateTime.now();
      await (database.update(
        database.transactions,
      )..where((row) => row.id.equals(transactionId))).write(
        TransactionsCompanion(
          userId: Value(replacement.userId),
          type: Value(replacement.type.storageValue),
          paymentSourceId: Value(replacement.paymentSourceId),
          destinationSourceId: Value(replacement.destinationSourceId),
          categoryId: Value(replacement.categoryId),
          amountMinor: Value(replacement.amountMinor),
          currencyCode: Value(replacement.currencyCode.trim().toUpperCase()),
          occurredAt: Value(replacement.occurredAt),
          note: Value(_blankToNull(replacement.note)),
          status: Value(replacement.status.storageValue),
          isSplit: Value(replacement.splits.isNotEmpty),
          recurringRuleId: Value(replacement.recurringRuleId),
          billSubscriptionId: Value(replacement.billSubscriptionId),
          createdFrom: Value(replacement.createdFrom),
          updatedAt: Value(now),
        ),
      );

      await _deleteSplits(transactionId);
      await _replaceSplits(transactionId, replacement.splits);
      if (replacement.status == TransactionStatus.posted) {
        await _applyBalanceEffect(replacement);
      }
    });
  }

  Future<void> softDeleteTransaction(int transactionId) async {
    await database.transaction(() async {
      final existing = await (database.select(
        database.transactions,
      )..where((row) => row.id.equals(transactionId))).getSingle();

      if (existing.deletedAt != null) {
        return;
      }

      if (existing.status == TransactionStatus.posted.storageValue) {
        await _revertBalanceEffect(existing);
      }

      final now = DateTime.now();
      await (database.update(
        database.transactions,
      )..where((row) => row.id.equals(transactionId))).write(
        TransactionsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  Future<void> _replaceSplits(
    int transactionId,
    List<TransactionSplitDraft> splits,
  ) async {
    if (splits.isEmpty) {
      return;
    }

    await database.batch((batch) {
      for (final split in splits) {
        batch.insert(
          database.transactionSplits,
          TransactionSplitsCompanion.insert(
            transactionId: transactionId,
            categoryId: split.categoryId,
            amountMinor: split.amountMinor,
            note: Value(_blankToNull(split.note)),
          ),
        );
      }
    });
  }

  Future<void> _deleteSplits(int transactionId) {
    return (database.delete(
      database.transactionSplits,
    )..where((row) => row.transactionId.equals(transactionId))).go();
  }

  Future<void> _applyBalanceEffect(FinanceTransactionDraft draft) async {
    switch (draft.type) {
      case TransactionType.expense:
        await _adjustSourceBalance(draft.paymentSourceId!, -draft.amountMinor);
      case TransactionType.income:
        await _adjustSourceBalance(draft.paymentSourceId!, draft.amountMinor);
      case TransactionType.transfer:
        await _adjustSourceBalance(draft.paymentSourceId!, -draft.amountMinor);
        await _adjustSourceBalance(
          draft.destinationSourceId!,
          draft.amountMinor,
        );
    }
  }

  Future<void> _revertBalanceEffect(FinanceTransaction record) async {
    switch (record.type) {
      case 'expense':
        await _adjustSourceBalance(record.paymentSourceId!, record.amountMinor);
      case 'income':
        await _adjustSourceBalance(
          record.paymentSourceId!,
          -record.amountMinor,
        );
      case 'transfer':
        await _adjustSourceBalance(record.paymentSourceId!, record.amountMinor);
        await _adjustSourceBalance(
          record.destinationSourceId!,
          -record.amountMinor,
        );
      default:
        throw StateError('Unsupported transaction type: ${record.type}');
    }
  }

  Future<void> _adjustSourceBalance(int sourceId, int deltaMinor) async {
    final source = await (database.select(
      database.paymentSources,
    )..where((row) => row.id.equals(sourceId))).getSingle();

    await (database.update(
      database.paymentSources,
    )..where((row) => row.id.equals(sourceId))).write(
      PaymentSourcesCompanion(
        currentBalanceMinor: Value(source.currentBalanceMinor + deltaMinor),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

void _validateDraft(FinanceTransactionDraft draft) {
  if (draft.amountMinor <= 0) {
    throw ArgumentError.value(draft.amountMinor, 'amountMinor');
  }
  if (draft.currencyCode.trim().length != 3) {
    throw ArgumentError.value(draft.currencyCode, 'currencyCode');
  }

  switch (draft.type) {
    case TransactionType.expense:
    case TransactionType.income:
      if (draft.paymentSourceId == null) {
        throw ArgumentError('A payment source is required.');
      }
      if (draft.categoryId == null && draft.splits.isEmpty) {
        throw ArgumentError('A category or split lines are required.');
      }
      if (draft.destinationSourceId != null) {
        throw ArgumentError('Income and expense cannot have a destination.');
      }
    case TransactionType.transfer:
      if (draft.paymentSourceId == null || draft.destinationSourceId == null) {
        throw ArgumentError('Transfer requires source and destination.');
      }
      if (draft.paymentSourceId == draft.destinationSourceId) {
        throw ArgumentError('Transfer source and destination must differ.');
      }
      if (draft.categoryId != null || draft.splits.isNotEmpty) {
        throw ArgumentError('Transfer cannot have categories or splits.');
      }
  }

  if (draft.splits.isNotEmpty) {
    final total = draft.splits.fold<int>(
      0,
      (sum, split) => sum + split.amountMinor,
    );
    if (total != draft.amountMinor) {
      throw ArgumentError('Split amounts must equal transaction amount.');
    }
  }
}

String? _blankToNull(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return normalized;
}
