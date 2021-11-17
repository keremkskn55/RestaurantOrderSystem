import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/services/auth.dart';

class CreateAccountViewContinueButton extends StatelessWidget {
  GlobalKey<FormState> createAccountKey;

  String emailStr;
  String passwordStr;
  String passwordAgainStr;

  Function callbackCheckPassword;

  CreateAccountViewContinueButton({
    required this.emailStr,
    required this.passwordStr,
    required this.passwordAgainStr,
    required this.createAccountKey,
    required this.callbackCheckPassword,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('Continue Create Account Button was pressed...');
        try {
          if (createAccountKey.currentState!.validate()) {
            if (passwordStr != passwordAgainStr) {
              callbackCheckPassword('Error', 'Please enter same password.');
            } else {
              print('create account....');
              final user = await Provider.of<Auth>(context, listen: false)
                  .registerWithEmail(emailStr, passwordStr);

              await Provider.of<Auth>(context, listen: false).signOut();
            }
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFF494949),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Text(
          'Continue to Create Account',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
