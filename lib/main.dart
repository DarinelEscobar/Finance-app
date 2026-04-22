import 'package:flutter/material.dart';

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1F8A70),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Tracker',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const List<CategoryItem> _categories = <CategoryItem>[
    CategoryItem(
      name: 'Housing',
      amount: r'$1,050',
      progress: 0.42,
      color: Color(0xFF3B82F6),
    ),
    CategoryItem(
      name: 'Food',
      amount: r'$460',
      progress: 0.26,
      color: Color(0xFFF59E0B),
    ),
    CategoryItem(
      name: 'Transport',
      amount: r'$180',
      progress: 0.18,
      color: Color(0xFF8B5CF6),
    ),
  ];

  static const List<TransactionEntry> _transactions = <TransactionEntry>[
    TransactionEntry(
      title: 'Salary',
      category: 'Income',
      amount: r'$4,200',
      time: 'Today - 09:15',
      icon: Icons.payments_rounded,
      accentColor: Color(0xFF10B981),
      isIncome: true,
    ),
    TransactionEntry(
      title: 'Groceries',
      category: 'Food',
      amount: r'-$68',
      time: 'Today - 13:40',
      icon: Icons.shopping_bag_rounded,
      accentColor: Color(0xFFF59E0B),
      isIncome: false,
    ),
    TransactionEntry(
      title: 'Electricity bill',
      category: 'Utilities',
      amount: r'-$92',
      time: 'Yesterday - 18:20',
      icon: Icons.flash_on_rounded,
      accentColor: Color(0xFF3B82F6),
      isIncome: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add transaction'),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _BackgroundLayer()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(name: 'Alex'),
                  const SizedBox(height: 20),
                  const _BalanceCard(),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(
                        child: _MetricCard(
                          label: 'Income',
                          value: r'$7,200',
                          icon: Icons.trending_up_rounded,
                          accentColor: Color(0xFF059669),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          label: 'Expenses',
                          value: r'$3,920',
                          icon: Icons.trending_down_rounded,
                          accentColor: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SectionHeader(
                    title: 'Spending by category',
                    subtitle: 'This month',
                  ),
                  const SizedBox(height: 12),
                  ..._categories.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CategoryTile(item: item),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _SectionHeader(
                    title: 'Recent transactions',
                    subtitle: 'Last 7 days',
                  ),
                  const SizedBox(height: 12),
                  ..._transactions.map(
                    (transaction) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TransactionTile(transaction: transaction),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF4F7FB), Color(0xFFFDFEFE)],
              ),
            ),
            child: SizedBox.expand(),
          ),
        ),
        const Positioned(
          top: -90,
          right: -40,
          child: _Glow(size: 220, color: Color(0x331F8A70)),
        ),
        const Positioned(
          top: 160,
          left: -70,
          child: _Glow(size: 180, color: Color(0x223B82F6)),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, $name',
                style: textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your money with confidence',
                style: textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF102A43),
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Color(0xFF1F8A70),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1F8A70)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331F8A70),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total balance',
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            r'$12,480.00',
            style: textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(
                child: _MiniStat(
                  label: 'Income',
                  value: r'$7,200',
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  label: 'Spent',
                  value: r'$3,920',
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final white = Colors.white;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6ECF2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF102A43),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: const Color(0xFF102A43),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          subtitle,
          style: textTheme.labelLarge?.copyWith(
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.item});

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6ECF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF102A43),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.amount,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(item.progress * 100).round()}%',
                style: textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF102A43),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFEAF0F6),
              valueColor: AlwaysStoppedAnimation<Color>(item.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final TransactionEntry transaction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final amountColor = transaction.isIncome
        ? const Color(0xFF059669)
        : const Color(0xFFDC2626);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6ECF2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(transaction.icon, color: transaction.accentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF102A43),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.category} - ${transaction.time}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: textTheme.titleMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem {
  const CategoryItem({
    required this.name,
    required this.amount,
    required this.progress,
    required this.color,
  });

  final String name;
  final String amount;
  final double progress;
  final Color color;

  IconData get icon {
    if (name == 'Housing') {
      return Icons.home_rounded;
    }

    if (name == 'Food') {
      return Icons.restaurant_rounded;
    }

    return Icons.directions_bus_rounded;
  }
}

class TransactionEntry {
  const TransactionEntry({
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
    required this.icon,
    required this.accentColor,
    required this.isIncome,
  });

  final String title;
  final String category;
  final String amount;
  final String time;
  final IconData icon;
  final Color accentColor;
  final bool isIncome;
}
