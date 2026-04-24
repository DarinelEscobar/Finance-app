import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../app/finance_scope.dart';
import '../account_setup/account_setup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isStarting = false;

  Future<void> _startAsGuest() async {
    if (_isStarting) {
      return;
    }

    setState(() => _isStarting = true);
    final repository = FinanceScope.of(context).repository;
    await repository.ensureGuestUser();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AccountSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _isStarting ? null : _startAsGuest,
                  child: const Text('Continue as guest'),
                ),
              ),
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: FinanceColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x221A146B),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Finance',
                style: textTheme.displaySmall?.copyWith(
                  color: FinanceColors.text,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Track your money with clarity.',
                style: textTheme.headlineMedium?.copyWith(
                  color: FinanceColors.text,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add income and expenses quickly, organize accounts, and keep your budget visible without sending your data anywhere.',
                style: textTheme.bodyLarge?.copyWith(
                  color: FinanceColors.muted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 32),
              _FeatureRow(
                icon: Icons.lock_rounded,
                title: 'Local-first',
                body: 'Your finance data stays on this device.',
              ),
              const SizedBox(height: 14),
              _FeatureRow(
                icon: Icons.speed_rounded,
                title: 'Fast daily use',
                body: 'Start with one account and add transactions in taps.',
              ),
              const Spacer(),
              FilledButton(
                onPressed: _isStarting ? null : _startAsGuest,
                child: _isStarting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Start tracking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE2DFFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: FinanceColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: FinanceColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: textTheme.bodyMedium?.copyWith(
                  color: FinanceColors.muted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
