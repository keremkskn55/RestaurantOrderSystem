import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// For controlling status of user sign-in, sign-out etc.
  Stream<User?> authStatus() {
    return _auth.authStateChanges();
  }

  /// Register with Email
  Future<User?> registerWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  /// Sign In with Email
  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  /// Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
