import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../app/finance_scope.dart';
import '../../core/money/money_parser.dart';
import '../../data/local/repositories/finance_repository.dart';
import '../../domain/services/finance_types.dart';
import '../dashboard/dashboard_page.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _openingBalanceController = TextEditingController();
  final _providerLabelController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();

  String _currencyCode = 'USD';
  PaymentSourceType _sourceType = PaymentSourceType.checking;
  String _budgetMode = 'monthly';
  bool _isSaving = false;

  @override
  void dispose() {
    _accountNameController.dispose();
    _openingBalanceController.dispose();
    _providerLabelController.dispose();
    _monthlyIncomeController.dispose();
    super.dispose();
  }

  Future<void> _saveSetup() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FinanceScope.of(context).repository.saveAccountSetup(
        AccountSetupDraft(
          currencyCode: _currencyCode,
          accountName: _accountNameController.text,
          sourceType: _sourceType,
          openingBalanceMinor: parseMoneyToMinorUnits(
            _openingBalanceController.text.isEmpty
                ? '0'
                : _openingBalanceController.text,
          ),
          providerLabel: _providerLabelController.text,
          monthlyIncomeEstimateMinor:
              _monthlyIncomeController.text.trim().isEmpty
              ? null
              : parseMoneyToMinorUnits(_monthlyIncomeController.text),
          budgetMode: _budgetMode,
        ),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Account setup saved')));
      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const DashboardPage()),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save account setup')),
      );
      setState(() => _isSaving = false);
    }
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: FinanceColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 672),
            child: Column(
              children: [
                _SetupHeader(onBack: _goBack),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(28, 16, 28, 120),
                      children: [
                        Text(
                          'Add Account',
                          style: textTheme.displaySmall?.copyWith(
                            color: FinanceColors.primary,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Let's get your finances organized. Enter your starting balance to begin tracking.",
                          style: textTheme.bodyLarge?.copyWith(
                            color: FinanceColors.muted,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _LabeledField(
                          label: 'Account Name',
                          child: TextFormField(
                            controller: _accountNameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: 'e.g., Main Checking',
                              suffixIcon: Icon(Icons.edit_square),
                            ),
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return 'Account name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 110,
                              child: _LabeledField(
                                label: 'Currency',
                                child: _CurrencySelector(
                                  value: _currencyCode,
                                  enabled: !_isSaving,
                                  onChanged: (value) {
                                    setState(() => _currencyCode = value);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _LabeledField(
                                label: 'Starting Balance',
                                child: TextFormField(
                                  controller: _openingBalanceController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  textInputAction: TextInputAction.done,
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: FinanceColors.text,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: const InputDecoration(
                                    prefixText: r'$ ',
                                    hintText: '0.00',
                                  ),
                                  validator: validateOptionalMoney,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _LabeledField(
                          label: 'Account Type',
                          child: _AccountTypeChips(
                            selected: _sourceType,
                            enabled: !_isSaving,
                            onChanged: (type) {
                              setState(() => _sourceType = type);
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Setup Details',
                          style: textTheme.titleMedium?.copyWith(
                            color: FinanceColors.text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'Provider Label',
                          child: TextFormField(
                            controller: _providerLabelController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: 'BBVA, Mercado Pago, Cash',
                              suffixIcon: Icon(Icons.account_balance_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _LabeledField(
                          label: 'Monthly Income Estimate',
                          child: TextFormField(
                            controller: _monthlyIncomeController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              prefixText: r'$ ',
                              hintText: 'Optional',
                            ),
                            validator: validateOptionalMoney,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _LabeledField(
                          label: 'Budget Preference',
                          child: _BudgetModeSelector(
                            value: _budgetMode,
                            enabled: !_isSaving,
                            onChanged: (value) {
                              setState(() => _budgetMode = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _SetupBottomAction(
        isSaving: _isSaving,
        onContinue: _saveSetup,
      ),
    );
  }
}

class _SetupHeader extends StatelessWidget {
  const _SetupHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              color: FinanceColors.primary,
              tooltip: 'Go back',
            ),
            const Expanded(child: _HeaderDots()),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

class _HeaderDots extends StatelessWidget {
  const _HeaderDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _Dot(isActive: true),
        SizedBox(width: 6),
        _Dot(isActive: false),
        SizedBox(width: 6),
        _Dot(isActive: false),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? FinanceColors.primary : const Color(0xFFE0E3E5),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: FinanceColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      enabled: enabled,
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'USD', child: Text('USD')),
        PopupMenuItem(value: 'MXN', child: Text('MXN')),
        PopupMenuItem(value: 'EUR', child: Text('EUR')),
      ],
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: FinanceColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}

class _AccountTypeChips extends StatelessWidget {
  const _AccountTypeChips({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final PaymentSourceType selected;
  final bool enabled;
  final ValueChanged<PaymentSourceType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeChip(
            label: 'Checking',
            type: PaymentSourceType.checking,
            selected: selected,
            enabled: enabled,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TypeChip(
            label: 'Savings',
            type: PaymentSourceType.savings,
            selected: selected,
            enabled: enabled,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TypeChip(
            label: 'Credit',
            type: PaymentSourceType.creditCard,
            selected: selected,
            enabled: enabled,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.type,
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final PaymentSourceType type;
  final PaymentSourceType selected;
  final bool enabled;
  final ValueChanged<PaymentSourceType> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == type;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: enabled ? () => onChanged(type) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE2DFFF) : const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFC3C0FF) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected ? const Color(0xFF100563) : FinanceColors.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SetupBottomAction extends StatelessWidget {
  const _SetupBottomAction({required this.isSaving, required this.onContinue});

  final bool isSaving;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x00F7F9FB),
              FinanceColors.background,
              FinanceColors.background,
            ],
          ),
        ),
        child: SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: isSaving ? null : onContinue,
            icon: isSaving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Continue'),
            label: isSaving
                ? const Text('Saving')
                : const Icon(Icons.arrow_forward_rounded),
          ),
        ),
      ),
    );
  }
}
