import 'package:flutter/material.dart';

import '../features/account_setup/account_setup_screen.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'finance_scope.dart';

enum StartupDestination { onboarding, accountSetup, dashboard }

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  late Future<StartupDestination> _destinationFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _destinationFuture = _resolveDestination();
  }

  Future<StartupDestination> _resolveDestination() async {
    final repository = FinanceScope.of(context).repository;
    final hasUser = await repository.hasLocalUser();
    if (!hasUser) {
      return StartupDestination.onboarding;
    }

    final setupComplete = await repository.isSetupComplete();
    if (!setupComplete) {
      return StartupDestination.accountSetup;
    }

    return StartupDestination.dashboard;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StartupDestination>(
      future: _destinationFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const _StartupLoadingScreen();
        }

        return switch (snapshot.data!) {
          StartupDestination.onboarding => const OnboardingScreen(),
          StartupDestination.accountSetup => const AccountSetupScreen(),
          StartupDestination.dashboard => const DashboardPage(),
        };
      },
    );
  }
}

class _StartupLoadingScreen extends StatelessWidget {
  const _StartupLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
