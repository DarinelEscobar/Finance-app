import 'finance_types.dart';

class DefaultCategoryDefinition {
  const DefaultCategoryDefinition({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });

  final String name;
  final CategoryType type;
  final String icon;
  final String color;
}

const defaultCategoryDefinitions = <DefaultCategoryDefinition>[
  DefaultCategoryDefinition(
    name: 'Food',
    type: CategoryType.expense,
    icon: 'restaurant',
    color: '#F59E0B',
  ),
  DefaultCategoryDefinition(
    name: 'Transport',
    type: CategoryType.expense,
    icon: 'directions_car',
    color: '#3B82F6',
  ),
  DefaultCategoryDefinition(
    name: 'Rent',
    type: CategoryType.expense,
    icon: 'home',
    color: '#6366F1',
  ),
  DefaultCategoryDefinition(
    name: 'Shopping',
    type: CategoryType.expense,
    icon: 'shopping_bag',
    color: '#EC4899',
  ),
  DefaultCategoryDefinition(
    name: 'Entertainment',
    type: CategoryType.expense,
    icon: 'movie',
    color: '#8B5CF6',
  ),
  DefaultCategoryDefinition(
    name: 'Health',
    type: CategoryType.expense,
    icon: 'health_and_safety',
    color: '#EF4444',
  ),
  DefaultCategoryDefinition(
    name: 'Bills',
    type: CategoryType.expense,
    icon: 'receipt_long',
    color: '#0EA5E9',
  ),
  DefaultCategoryDefinition(
    name: 'Education',
    type: CategoryType.expense,
    icon: 'school',
    color: '#14B8A6',
  ),
  DefaultCategoryDefinition(
    name: 'Travel',
    type: CategoryType.expense,
    icon: 'flight',
    color: '#06B6D4',
  ),
  DefaultCategoryDefinition(
    name: 'Savings',
    type: CategoryType.expense,
    icon: 'savings',
    color: '#10B981',
  ),
  DefaultCategoryDefinition(
    name: 'Gifts',
    type: CategoryType.expense,
    icon: 'redeem',
    color: '#F97316',
  ),
  DefaultCategoryDefinition(
    name: 'Other',
    type: CategoryType.expense,
    icon: 'more_horiz',
    color: '#777682',
  ),
  DefaultCategoryDefinition(
    name: 'Salary',
    type: CategoryType.income,
    icon: 'payments',
    color: '#059669',
  ),
  DefaultCategoryDefinition(
    name: 'Freelance',
    type: CategoryType.income,
    icon: 'work',
    color: '#0D9488',
  ),
  DefaultCategoryDefinition(
    name: 'Investments',
    type: CategoryType.income,
    icon: 'trending_up',
    color: '#16A34A',
  ),
  DefaultCategoryDefinition(
    name: 'Gifts',
    type: CategoryType.income,
    icon: 'redeem',
    color: '#22C55E',
  ),
  DefaultCategoryDefinition(
    name: 'Other',
    type: CategoryType.income,
    icon: 'more_horiz',
    color: '#64748B',
  ),
];
