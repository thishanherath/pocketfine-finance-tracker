import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TransactionService {


  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;


  final FirebaseAuth auth =
      FirebaseAuth.instance;

  String get uid => auth.currentUser!.uid;

  Future<void> addTransaction({

    required String title,

    required double amount,

    required String type,

    required String category,

  }) async {

    await firestore

        .collection("users")

        .doc(uid)

        .collection("transactions")

        .add({

      "title":title,

      "amount":amount,

      "type":type,

      "category":category,

      "date":DateTime.now(),

    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactions() {
    return firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .orderBy("date", descending: true)
        .snapshots();
  }

   Future<void> deleteTransaction(String transactionId) async {
    await firestore
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(transactionId)
        .delete();
  }

  Future<void> updateTransaction({
    required String transactionId,
    required String title,
    required double amount,
    required String type,
    required String category,
  }) async {
    await firestore
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