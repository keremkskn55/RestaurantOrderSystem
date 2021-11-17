import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/services/auth.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Home View...'),
            TextButton(
              onPressed: () async {
                await Provider.of<Auth>(context, listen: false).signOut();
              },
              child: Text('Sign Out!'),
            ),
          ],
        ),
      ),
    );
  }
}
