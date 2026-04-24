import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../app/finance_scope.dart';
import '../onboarding/onboarding_screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _confirmReset(BuildContext context) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset local data?'),
        content: const Text(
          'This temporary testing action deletes all local finance data and returns to onboarding.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset != true || !context.mounted) {
      return;
    }

    await FinanceScope.of(context).repository.resetLocalData();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add transaction'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: FinanceColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total balance',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r'$0.00',
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent transactions',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const _EmptyDashboardState(),
            const SizedBox(height: 24),
            _TemporaryResetCard(onReset: () => _confirmReset(context)),
          ],
        ),
      ),
    );
  }
}

class _TemporaryResetCard extends StatelessWidget {
  const _TemporaryResetCard({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science_rounded, color: Color(0xFFC2410C)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Testing sample',
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF7C2D12),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Reset all local data and start again from onboarding. This sample control should be removed later.',
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF9A3412),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Reset local data'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFC2410C),
              side: const BorderSide(color: Color(0xFFF97316)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDashboardState extends StatelessWidget {
  const _EmptyDashboardState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FinanceColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_rounded,
            color: FinanceColors.muted,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Your recent activity will appear here after setup.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: FinanceColors.muted),
          ),
        ],
      ),
    );
  }
}
