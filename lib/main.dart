import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listuserwithfirebase/view/viewuser.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(MainApp());
  } catch (e) {
    print('Eror initialize: ${e}');
  }
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ViewUser(),
    );
  }
}
