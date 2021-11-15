import 'package:flutter/material.dart';

class SignInViewCreateAccountButton extends StatelessWidget {
  const SignInViewCreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        print('Create Account button...');
      },
      child: Container(
        width: (size.width - 32) / 2,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFF494949),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: const Center(
          child: Text(
            'Create Account',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
