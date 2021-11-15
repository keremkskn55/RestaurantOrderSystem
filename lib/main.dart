import 'package:flutter/material.dart';
import 'package:restaurant_order_system/screens/sign_in_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInView(),
    );
  }
}
