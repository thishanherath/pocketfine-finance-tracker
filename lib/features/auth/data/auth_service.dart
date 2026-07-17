import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;



  Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {

    try {

      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      User? user = credential.user;


      if (user != null) {

        await _firestore
            .collection("users")
            .doc(user.uid)
            .set({

          "uid": user.uid,
          "name": name,
          "email": email,
          "createdAt": DateTime.now(),

        });

      }


      return user;


    } catch(e) {

      throw Exception(e.toString());

    }

  }



  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {


    try {

      UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );


      return credential.user;


    } catch(e){

      throw Exception(e.toString());

    }

  }




  Future<void> logout() async {

    // await _auth.signOut();
    await FirebaseAuth.instance.signOut();

  }



  User? get currentUser {

    return _auth.currentUser;

  }


}