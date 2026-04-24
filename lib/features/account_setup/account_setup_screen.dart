import 'package:flutter/material.dart';

class AccountSetupScreen extends StatelessWidget {
  const AccountSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account setup')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Set up your account', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
