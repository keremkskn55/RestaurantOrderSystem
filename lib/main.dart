import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_order_system/on_board.dart';
import 'package:restaurant_order_system/screens/sign_in_view.dart';
import 'package:restaurant_order_system/services/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Provider<Auth>(
            create: (_) => Auth(),
            child: const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: OnBoard(),
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
