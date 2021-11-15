import 'package:flutter/material.dart';

class SignInViewSignInButton extends StatelessWidget {
  const SignInViewSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Sign In Button...');
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
