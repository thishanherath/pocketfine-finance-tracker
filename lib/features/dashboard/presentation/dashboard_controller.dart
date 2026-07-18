import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketfine_finance_tracker/features/transactions/data/transaction_repository.dart';

enum DateFilter { allTime, thisMonth, lastMonth }

final dateFilterProvider = StateProvider<DateFilter>((ref) => DateFilter.thisMonth);

/// This class holds all the processed data the Dashboard needs to display.
class DashboardState {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final double food;
  final double transport;
  final double shopping;
  final double bills;
  final double other;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> transactions;

  DashboardState({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.food,
    required this.transport,
    required this.shopping,
    required this.bills,
    required this.other,
    required this.transactions,
  });
}

/// This provider listens to the Firestore stream and processes the data (the "math")
/// every time the stream updates. It returns a clean DashboardState object to the UI.
final dashboardControllerProvider = StreamProvider<DashboardState>((ref) {
  // We get the repository from Riverpod
  final repository = ref.watch(transactionRepositoryProvider);
  
  // Watch the current date filter
  final filter = ref.watch(dateFilterProvider);

  DateTime? startDate;
  DateTime? endDate;

  final now = DateTime.now();
  if (filter == DateFilter.thisMonth) {
    startDate = DateTime(now.year, now.month, 1);
    // Go to the 0th day of next month to get the last day of this month
    endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  } else if (filter == DateFilter.lastMonth) {
    startDate = DateTime(now.year, now.month - 1, 1);
    endDate = DateTime(now.year, now.month, 0, 23, 59, 59);
  }

  // We listen to the raw stream from Firebase with our date filters applied
  return repository.getTransactions(startDate: startDate, endDate: endDate).map((snapshot) {
    double totalIncome = 0;
    double totalExpense = 0;
    double food = 0;
    double transport = 0;
    double shopping = 0;
    double bills = 0;
    double other = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data["amount"] as num).toDouble();

      if (data["type"] == "income") {
        totalIncome += amount;
      } else {
        totalExpense += amount;
        switch (data["category"]) {
          case "Food":
            food += amount;
            break;
          case "Transport":
            transport += amount;
            break;
          case "Shopping":
            shopping += amount;
            break;
          case "Bills":
            bills += amount;
            break;
          default:
            other += amount;
        }
      }
    }

    final balance = totalIncome - totalExpense;

    // Return the clean processed data object
    return DashboardState(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: balance,
      food: food,
      transport: transport,
      shopping: shopping,
      bills: bills,
      other: other,
      transactions: snapshot.docs,
    );
  });
});
