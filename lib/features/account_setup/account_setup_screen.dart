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
  final _providerLabelController = TextEditingController();
  final _openingBalanceController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();

  String _currencyCode = 'MXN';
  PaymentSourceType _sourceType = PaymentSourceType.cash;
  String _budgetMode = 'monthly';
  bool _isSaving = false;

  @override
  void dispose() {
    _accountNameController.dispose();
    _providerLabelController.dispose();
    _openingBalanceController.dispose();
    _monthlyIncomeController.dispose();
    super.dispose();
  }

  Future<void> _saveSetup() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    final repository = FinanceScope.of(context).repository;

    try {
      await repository.saveAccountSetup(
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Account setup')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
            children: [
              Text(
                'Set up your account',
                style: textTheme.headlineMedium?.copyWith(
                  color: FinanceColors.text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your currency and create the first account stored locally on this device.',
                style: textTheme.bodyLarge?.copyWith(
                  color: FinanceColors.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              DropdownButtonFormField<String>(
                initialValue: _currencyCode,
                decoration: const InputDecoration(labelText: 'Currency'),
                items: const [
                  DropdownMenuItem(value: 'MXN', child: Text('MXN')),
                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                  DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                ],
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _currencyCode = value ?? 'MXN'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Account name',
                  hintText: 'Cash, BBVA, Mercado Pago',
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Account name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PaymentSourceType>(
                initialValue: _sourceType,
                decoration: const InputDecoration(labelText: 'Account type'),
                items: const [
                  DropdownMenuItem(
                    value: PaymentSourceType.cash,
                    child: Text('Cash'),
                  ),
                  DropdownMenuItem(
                    value: PaymentSourceType.checking,
                    child: Text('Checking'),
                  ),
                  DropdownMenuItem(
                    value: PaymentSourceType.savings,
                    child: Text('Savings'),
                  ),
                  DropdownMenuItem(
                    value: PaymentSourceType.digitalWallet,
                    child: Text('Digital wallet'),
                  ),
                  DropdownMenuItem(
                    value: PaymentSourceType.investment,
                    child: Text('Investment'),
                  ),
                ],
                onChanged: _isSaving
                    ? null
                    : (value) => setState(
                        () => _sourceType = value ?? PaymentSourceType.cash,
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _providerLabelController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Provider label',
                  hintText: 'Optional',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _openingBalanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Starting balance',
                  hintText: '0.00',
                ),
                validator: validateOptionalMoney,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _monthlyIncomeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Monthly income estimate',
                  hintText: 'Optional',
                ),
                validator: validateOptionalMoney,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _budgetMode,
                decoration: const InputDecoration(labelText: 'Budgeting'),
                items: const [
                  DropdownMenuItem(
                    value: 'monthly',
                    child: Text('Monthly by default'),
                  ),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(
                    value: 'custom',
                    child: Text('Custom later'),
                  ),
                ],
                onChanged: _isSaving
                    ? null
                    : (value) =>
                          setState(() => _budgetMode = value ?? 'monthly'),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveSetup,
                icon: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: const Text('Save setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
