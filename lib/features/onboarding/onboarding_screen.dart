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
    return Scaffold(
      backgroundColor: FinanceColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const Expanded(flex: 12, child: _OnboardingVisual()),
                _OnboardingActionPanel(
                  isStarting: _isStarting,
                  onStart: _startAsGuest,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingVisual extends StatelessWidget {
  const _OnboardingVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [FinanceColors.surface, FinanceColors.background],
        ),
      ),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(48),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x141A146B),
                    blurRadius: 40,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: const _FinanceIllustration(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FinanceIllustration extends StatelessWidget {
  const _FinanceIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(-0.25, -0.2),
          child: Container(
            width: 144,
            height: 116,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DFFF),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: FinanceColors.primary,
              size: 56,
            ),
          ),
        ),
        const Positioned(
          right: 46,
          top: 58,
          child: _Coin(size: 58, label: r'$'),
        ),
        const Positioned(
          left: 54,
          bottom: 64,
          child: _Coin(size: 46, label: '+'),
        ),
        Positioned(
          right: 54,
          bottom: 56,
          child: Container(
            width: 72,
            height: 92,
            decoration: BoxDecoration(
              color: const Color(0xFF82F5C1),
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: FinanceColors.secondary,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}

class _Coin extends StatelessWidget {
  const _Coin({required this.size, required this.label});

  final double size;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFC3C0FF),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: FinanceColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}

class _OnboardingActionPanel extends StatelessWidget {
  const _OnboardingActionPanel({
    required this.isStarting,
    required this.onStart,
  });

  final bool isStarting;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 48),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 32,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _StepDots(),
          const SizedBox(height: 32),
          Text(
            'Master your money, effortlessly.',
            textAlign: TextAlign.center,
            style: textTheme.displaySmall?.copyWith(
              color: const Color(0xFF100563),
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Track spending, build budgets, and uncover insights that bring financial serenity.',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: FinanceColors.muted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: isStarting ? null : onStart,
              child: isStarting
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Get Started'),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: null,
                child: Text(
                  'Sign In',
                  style: textTheme.bodyMedium?.copyWith(
                    color: FinanceColors.primary.withValues(alpha: 0.45),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: FinanceColors.border,
                  shape: BoxShape.circle,
                ),
              ),
              TextButton(
                onPressed: isStarting ? null : onStart,
                child: const Text('Continue as Guest'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 8,
          decoration: BoxDecoration(
            color: FinanceColors.primary,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 8),
        const _InactiveDot(),
        const SizedBox(width: 8),
        const _InactiveDot(),
      ],
    );
  }
}

class _InactiveDot extends StatelessWidget {
  const _InactiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFD8DADC),
        shape: BoxShape.circle,
      ),
    );
  }
}
