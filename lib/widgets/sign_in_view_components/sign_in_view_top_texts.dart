import 'package:flutter/material.dart';

class SignInViewTopComponents extends StatelessWidget {
  const SignInViewTopComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        /// Title
        Text(
          'Restaurant Order System',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),

        ///Divider
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Divider(
            height: 20,
            color: Colors.white,
          ),
        ),

        ///Subtitle
        Text(
          'Sign In Page',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
