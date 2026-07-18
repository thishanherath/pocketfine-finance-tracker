import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TransactionRepository {
  Future<void> addTransaction({
    required String title,
    required double amount,
    required String type,
    required String category,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<void> deleteTransaction(String transactionId);

  Future<void> updateTransaction({
    required String transactionId,
    required String title,
    required double amount,
    required String type,
    required String category,
  });
}

class FirebaseTransactionRepository implements TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  @override
  Future<void> addTransaction({
    required String title,
    required double amount,
    required String type,
    required String category,
  }) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .add({
      "title": title,
      "amount": amount,
      "type": type,
      "category": category,
      "date": DateTime.now(),
    });
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query<Map<String, dynamic>> query = _firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .orderBy("date", descending: true);

    if (startDate != null) {
      query = query.where("date", isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where("date", isLessThanOrEqualTo: endDate);
    }

    return query.snapshots();
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(transactionId)
        .delete();
  }

  @override
  Future<void> updateTransaction({
    required String transactionId,
    required String title,
    required double amount,
    required String type,
    required String category,
  }) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(transactionId)
        .update({
      "title": title,
      "amount": amount,
      "type": type,
      "category": category,
    });
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return FirebaseTransactionRepository();
});
