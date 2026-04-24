import 'package:drift/drift.dart';

@DataClassName('UserRecord')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().nullable()();
  TextColumn get passwordHash => text().nullable()();
  BoolColumn get isGuest => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('UserSettingsRecord')
class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  IntColumn get startOfMonthDay => integer().withDefault(const Constant(1))();
  TextColumn get budgetMode => text().withDefault(const Constant('monthly'))();
  BoolColumn get balanceTrackingEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get monthlyIncomeEstimateMinor => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('PaymentSourceRecord')
class PaymentSources extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get providerLabel => text().nullable()();
  TextColumn get type => text()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  IntColumn get openingBalanceMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get currentBalanceMinor =>
      integer().withDefault(const Constant(0))();
  BoolColumn get trackBalance => boolean().withDefault(const Constant(true))();
  BoolColumn get includeInTotalBalance =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('CategoryRecord')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get type => text()();
  TextColumn get icon => text().withDefault(const Constant('category'))();
  TextColumn get color => text().withDefault(const Constant('#777682'))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get parentCategoryId =>
      integer().nullable().references(Categories, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('FinanceTransaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get type => text()();
  @ReferenceName('sourceTransactions')
  IntColumn get paymentSourceId =>
      integer().nullable().references(PaymentSources, #id)();
  @ReferenceName('destinationTransactions')
  IntColumn get destinationSourceId =>
      integer().nullable().references(PaymentSources, #id)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  IntColumn get amountMinor => integer()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('posted'))();
  BoolColumn get isSplit => boolean().withDefault(const Constant(false))();
  IntColumn get recurringRuleId =>
      integer().nullable().references(RecurringRules, #id)();
  IntColumn get billSubscriptionId =>
      integer().nullable().references(BillSubscriptions, #id)();
  TextColumn get createdFrom => text().withDefault(const Constant('manual'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

@DataClassName('TransactionSplitRecord')
class TransactionSplits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get amountMinor => integer()();
  TextColumn get note => text().nullable()();
}

@DataClassName('TagRecord')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text().withLength(min: 1, max: 48)();
  TextColumn get color => text().nullable()();
}

class TransactionTags extends Table {
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column<Object>> get primaryKey => {transactionId, tagId};
}

@DataClassName('BudgetRecord')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get amountMinor => integer()();
  TextColumn get periodType => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get alertThresholdPercent =>
      integer().withDefault(const Constant(80))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('RecurringRuleRecord')
class RecurringRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get type => text()();
  IntColumn get paymentSourceId => integer().references(PaymentSources, #id)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  IntColumn get amountMinor => integer()();
  TextColumn get note => text().nullable()();
  TextColumn get frequency => text()();
  IntColumn get intervalCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get nextRunAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get autoPost => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('SavingsGoalRecord')
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get targetAmountMinor => integer()();
  IntColumn get currentAmountMinor =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  IntColumn get linkedSourceId =>
      integer().nullable().references(PaymentSources, #id)();
  TextColumn get color => text().nullable()();
  TextColumn get icon => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('GoalContributionRecord')
class GoalContributions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer().references(SavingsGoals, #id)();
  IntColumn get transactionId =>
      integer().nullable().references(Transactions, #id)();
  IntColumn get paymentSourceId => integer().references(PaymentSources, #id)();
  IntColumn get amountMinor => integer()();
  DateTimeColumn get contributedAt => dateTime()();
  TextColumn get note => text().nullable()();
}

@DataClassName('BillSubscriptionRecord')
class BillSubscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get defaultPaymentSourceId =>
      integer().nullable().references(PaymentSources, #id)();
  IntColumn get amountMinor => integer()();
  TextColumn get frequency => text()();
  IntColumn get dueDay => integer().nullable()();
  DateTimeColumn get nextDueDate => dateTime()();
  BoolColumn get isSubscription =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get reminderDaysBefore =>
      integer().withDefault(const Constant(3))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('NotificationRecord')
class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get type => text()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get body => text()();
  TextColumn get relatedEntityType => text().nullable()();
  IntColumn get relatedEntityId => integer().nullable()();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
