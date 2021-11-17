import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/services/auth.dart';

class SignInViewSignInButton extends StatelessWidget {
  GlobalKey<FormState> signInKey;

  String emailStr;
  String passwordStr;

  SignInViewSignInButton({
    required this.emailStr,
    required this.passwordStr,
    required this.signInKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('Sign In Button...');
        if (signInKey.currentState!.validate()) {
          try {
            final user = await Provider.of<Auth>(context, listen: false)
                .signInWithEmail(emailStr, passwordStr);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              print('Wrong password provided for that user.');
            }
          }
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF25E37D),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: const Center(
          child: Icon(
            Icons.done,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
