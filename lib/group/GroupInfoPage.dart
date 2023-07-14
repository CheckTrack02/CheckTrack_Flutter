import 'package:flutter/material.dart';
import 'package:checktrack/utilsSystem.dart';

class GroupInfoPage extends StatefulWidget {
  final int groupNo;
  GroupInfoPage({required this.groupNo});


  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState(groupNo);
}

class _GroupInfoPageState extends State<GroupInfoPage> {

  _GroupInfoPageState(this.groupNo){
    print(groupNo);
  }

  final int groupNo;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Club'),
        elevation: 0.0,
        backgroundColor: colorScheme.color6,
        centerTitle: true,
      ),
      body: Column(),
    );
  }
}