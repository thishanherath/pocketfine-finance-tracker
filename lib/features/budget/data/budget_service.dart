import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class BudgetService {


  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;


  final FirebaseAuth auth =
      FirebaseAuth.instance;



  String get uid =>
      auth.currentUser!.uid;




  Future<void> addBudget({

    required String category,

    required double limit,

  }) async {


    await firestore

        .collection("users")

        .doc(uid)

        .collection("budgets")

        .add({

      "category":category,

      "limit":limit,

    });


  }





  Stream<QuerySnapshot<Map<String,dynamic>>>
  getBudgets(){


    return firestore

        .collection("users")

        .doc(uid)

        .collection("budgets")

        .snapshots();


  }




  Future<void> deleteBudget(
      String id
      ) async{


    await firestore

        .collection("users")

        .doc(uid)

        .collection("budgets")

        .doc(id)

        .delete();


  }


}