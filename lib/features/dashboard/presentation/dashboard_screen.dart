import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketfine_finance_tracker/features/auth/data/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketfine_finance_tracker/features/dashboard/presentation/dashboard_controller.dart';
import 'package:pocketfine_finance_tracker/features/transactions/data/transaction_repository.dart';
import 'package:pocketfine_finance_tracker/features/dashboard/widgets/expense_chart.dart';
import 'package:pocketfine_finance_tracker/features/dashboard/widgets/monthly_chart.dart';
import 'package:pocketfine_finance_tracker/features/dashboard/widgets/premium_balance_card.dart';
import 'package:pocketfine_finance_tracker/features/dashboard/widgets/premium_money_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PocketFine"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_balance_wallet,
            ),
            onPressed: () {
              context.push('/budget');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).logout();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
      body: ref.watch(dashboardControllerProvider).when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => const Center(
              child: Text("Something went wrong"),
            ),
            data: (state) {
              final docs = state.transactions;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<DateFilter>(
                        segments: const [
                          ButtonSegment(value: DateFilter.thisMonth, label: Text('This Month')),
                          ButtonSegment(value: DateFilter.lastMonth, label: Text('Last Month')),
                          ButtonSegment(value: DateFilter.allTime, label: Text('All Time')),
                        ],
                        selected: {ref.watch(dateFilterProvider)},
                        onSelectionChanged: (Set<DateFilter> newSelection) {
                          ref.read(dateFilterProvider.notifier).state = newSelection.first;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    PremiumBalanceCard(balance: state.balance),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: PremiumMoneyCard(
                            title: "Income",
                            amount: "Rs ${state.totalIncome.toStringAsFixed(2)}",
                            icon: Icons.arrow_downward,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: PremiumMoneyCard(
                            title: "Expense",
                            amount: "Rs ${state.totalExpense.toStringAsFixed(2)}",
                            icon: Icons.arrow_upward,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ExpenseChart(
                      food: state.food,
                      transport: state.transport,
                      shopping: state.shopping,
                      bills: state.bills,
                      other: state.other,
                    ),
                    const SizedBox(height: 30),
                    MonthlyChart(
                      income: state.totalIncome,
                      expense: state.totalExpense,
                    ),
                    const Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (docs.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "No transactions yet",
                          ),
                        ),
                      ),
                    ...docs.map((doc) {
                      final data = doc.data();
                      final bool isIncome = data["type"] == "income";

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                            ),
                          ),
                          title: Text(
                            data["title"],
                          ),
                          subtitle: Text(
                            data["category"],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${isIncome ? "+" : "-"} Rs ${data["amount"]}",
                                style: TextStyle(
                                  color: isIncome ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.push('/edit-transaction', extra: {
                                    'id': doc.id,
                                    'title': data["title"],
                                    'amount': (data["amount"] as num).toDouble(),
                                    'type': data["type"],
                                    'category': data["category"],
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await ref
                                      .read(transactionRepositoryProvider)
                                      .deleteTransaction(doc.id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-transaction');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}