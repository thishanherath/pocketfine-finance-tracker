import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is our Repository Interface (The Blueprint).
/// The UI will talk to this blueprint without needing to know that Firebase is being used.
abstract class AuthRepository {
  Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
  });

  Future<User?> loginUser({
    required String email,
    required String password,
  });

  Future<void> logout();

  User? get currentUser;
}

/// This is the actual implementation of the blueprint using Firebase.
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": name,
          "email": email,
          "createdAt": DateTime.now(),
        });
      }

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  User? get currentUser {
    return _auth.currentUser;
  }
}

/// This is the Riverpod Provider. 
/// Anywhere in our app, we can use `ref.read(authRepositoryProvider)` to access our repository safely.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});
