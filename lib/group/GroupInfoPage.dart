import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:checktrack/system/utilsSystem.dart';
=======
import 'package:checktrack/utilsSystem.dart';
import 'package:checktrack/db/GroupEntity.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:checktrack/system/apiSystem.dart';
>>>>>>> 891a3ca7debb453444dcd54bb36a6e2c3e80cd3c

class GroupInfoPage extends StatefulWidget {
  final int groupNo;

  void getGroupEntity(){
    
  }
  GroupInfoPage({required this.groupNo});



  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState(groupNo);
}

class _GroupInfoPageState extends State<GroupInfoPage> {

  _GroupInfoPageState(this.groupNo){
    loadGroupEntity();
  }

  void loadGroupEntity() async{
    groupEntity = await GroupAPISystem.getGroupEntity(groupNo);
    print(groupEntity);
  }

  late final GroupEntity groupEntity;
  final int groupNo;
  late List<UserEntity> userList;

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