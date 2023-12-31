import 'package:checktrack/timer/TimerStartPage.dart';
import 'package:flutter/material.dart';
import 'package:checktrack/loginPage.dart';
import 'package:checktrack/group/GroupInfoPage.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:checktrack/group/GroupPage.dart';

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

class MyMain extends StatelessWidget {
  int userNo;
  MyMain({required this.userNo});
  final pageFlipKey = GlobalKey<PageFlipBuilderState>();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: Container(
        // add a black background to prevent flickering on Android when the page flips
        color: Colors.black,
        child: PageFlipBuilder(
          key: pageFlipKey,
          frontBuilder: (_) => TimerStartPage(
            onFlip: () => pageFlipKey.currentState?.flip(),
          ),
          backBuilder: (_) => GroupPage(
            userNo: userNo,
            onFlip: () => pageFlipKey.currentState?.flip(),
          ),
          maxTilt: 0.003,
          maxScale: 0.2,
          onFlipComplete: (isFrontSide) => print('front: $isFrontSide'),
        
        ),
      ),
    );
  }
}