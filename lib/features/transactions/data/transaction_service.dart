import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TransactionService {


  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;


  final FirebaseAuth auth =
      FirebaseAuth.instance;



  Future<void> addTransaction({

    required String title,

    required double amount,

    required String type,

    required String category,

  }) async {


    final uid =
    auth.currentUser!.uid;



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

}