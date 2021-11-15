import 'package:flutter/material.dart';

class CreateAccountViewContinueButton extends StatelessWidget {
  const CreateAccountViewContinueButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
