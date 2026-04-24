int parseMoneyToMinorUnits(String value) {
  final normalized = value.trim().replaceAll(',', '');
  if (normalized.isEmpty) {
    throw const FormatException('Money value is required.');
  }

  final parsed = double.tryParse(normalized);
  if (parsed == null || parsed < 0) {
    throw FormatException('Invalid money value: $value');
  }

  return (parsed * 100).round();
}

String? validateOptionalMoney(String? value) {
  final normalized = value?.trim() ?? '';
  if (normalized.isEmpty) {
    return null;
  }

  try {
    parseMoneyToMinorUnits(normalized);
    return null;
  } on FormatException {
    return 'Enter a valid amount';
  }
}
