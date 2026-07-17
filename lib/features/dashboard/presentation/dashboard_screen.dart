import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocketfine_finance_tracker/features/auth/data/auth_service.dart';
import 'package:pocketfine_finance_tracker/features/auth/presentation/login_screen.dart';
import 'package:pocketfine_finance_tracker/features/transactions/data/transaction_service.dart';
import 'package:pocketfine_finance_tracker/features/transactions/presentation/add_transaction_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final TransactionService transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PockeFine"),

        actions: [

          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {

              await AuthService().logout();

              if (context.mounted) {

                Navigator.pushAndRemoveUntil(
                  context,

                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),

                  (route) => false,
                );

              }

            },
          ),

        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: transactionService.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          double totalIncome = 0;
          double totalExpense = 0;

          for (var doc in docs) {
            final data = doc.data();

            final amount =
                (data["amount"] as num).toDouble();

            if (data["type"] == "income") {
              totalIncome += amount;
            } else {
              totalExpense += amount;
            }
          }

          final balance =
              totalIncome - totalExpense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Text(
                  "Good Morning 👋",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _balanceCard(balance),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _moneyCard(
                        title: "Income",
                        amount:
                            "Rs ${totalIncome.toStringAsFixed(2)}",
                        icon: Icons.arrow_downward,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: _moneyCard(
                        title: "Expense",
                        amount:
                            "Rs ${totalExpense.toStringAsFixed(2)}",
                        icon: Icons.arrow_upward,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

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

                  final bool isIncome =
                      data["type"] == "income";

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          isIncome
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                        ),
                      ),

                      title: Text(
                        data["title"],
                      ),

                      subtitle: Text(
                        data["category"],
                      ),

                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            "${isIncome ? "+" : "-"} Rs ${data["amount"]}",
                            style: TextStyle(
                              color: isIncome
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          IconButton(
                            onPressed: () async {
                              await transactionService
                                  .deleteTransaction(
                                      doc.id);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _balanceCard(double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "Current Balance",
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Rs ${balance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),

          const SizedBox(height: 10),

          Text(title),

          const SizedBox(height: 5),

          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}