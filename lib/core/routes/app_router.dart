import 'package:go_router/go_router.dart';
import 'package:pocketfine_finance_tracker/features/auth/presentation/login_screen.dart';
import 'package:pocketfine_finance_tracker/features/auth/presentation/register_screen.dart';
import 'package:pocketfine_finance_tracker/features/dashboard/presentation/dashboard_screen.dart';
import 'package:pocketfine_finance_tracker/features/transactions/presentation/add_transaction_screen.dart';
import 'package:pocketfine_finance_tracker/features/transactions/presentation/edit_transaction_screen.dart';
import 'package:pocketfine_finance_tracker/features/budget/presentation/budget_screen.dart';
import 'package:pocketfine_finance_tracker/features/budget/presentation/add_budget_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/add-transaction',
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '/budget',
      builder: (context, state) => BudgetScreen(),
    ),
    GoRoute(
      path: '/add-budget',
      builder: (context, state) => const AddBudgetScreen(),
    ),
    GoRoute(
      path: '/edit-transaction',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return EditTransactionScreen(
          transactionId: data['id'],
          initialTitle: data['title'],
          initialAmount: data['amount'],
          initialType: data['type'],
          initialCategory: data['category'],
        );
      },
    ),
  ],
);
