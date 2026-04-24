enum TransactionType {
  expense('expense'),
  income('income'),
  transfer('transfer');

  const TransactionType(this.storageValue);

  final String storageValue;
}

enum CategoryType {
  expense('expense'),
  income('income');

  const CategoryType(this.storageValue);

  final String storageValue;
}

enum PaymentSourceType {
  cash('cash'),
  checking('checking'),
  savings('savings'),
  debitCard('debit_card'),
  creditCard('credit_card'),
  digitalWallet('digital_wallet'),
  investment('investment');

  const PaymentSourceType(this.storageValue);

  final String storageValue;
}

enum TransactionStatus {
  posted('posted'),
  pending('pending'),
  voided('void');

  const TransactionStatus(this.storageValue);

  final String storageValue;
}

enum BudgetPeriodType {
  weekly('weekly'),
  monthly('monthly'),
  threeMonths('3_months'),
  sixMonths('6_months'),
  yearly('yearly'),
  custom('custom');

  const BudgetPeriodType(this.storageValue);

  final String storageValue;
}

enum RecurringFrequency {
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  yearly('yearly');

  const RecurringFrequency(this.storageValue);

  final String storageValue;
}

enum ThemePreference {
  system('system'),
  light('light'),
  dark('dark');

  const ThemePreference(this.storageValue);

  final String storageValue;
}
