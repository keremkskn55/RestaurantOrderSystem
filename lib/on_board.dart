import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/screens/home_view.dart';
import 'package:restaurant_order_system/screens/sign_in_view.dart';
import 'package:restaurant_order_system/services/auth.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  @override
  Widget build(BuildContext context) {
    final _authStatus = Provider.of<Auth>(context, listen: false).authStatus();

    return StreamBuilder<User?>(
      stream: _authStatus,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return snapshot.data != null ? HomeView() : SignInView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
