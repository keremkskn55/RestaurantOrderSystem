import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/screens/create_account_name_and_floor_number_view.dart';
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

        if (createAccountKey.currentState!.validate()) {
          if (passwordStr != passwordAgainStr) {
            callbackCheckPassword('Error', 'Please enter same password.');
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateAccountNameAndFloorNumberView(
                          email: emailStr,
                          password: passwordStr,
                        )));
          }
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
