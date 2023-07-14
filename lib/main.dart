import 'package:flutter/material.dart';
import 'package:checktrack/loginPage.dart';

void main() {
  runApp(MyApp());
}

class MyAppState extends ChangeNotifier {

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LoginPage(),
    );
  }
}
