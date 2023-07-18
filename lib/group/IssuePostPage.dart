import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/db/IssueEntity.dart';
import 'package:checktrack/group/IssuePage.dart';

class IssuePostPage extends StatefulWidget {
  final int groupNo;
  final int userNo;
  Map<int, String> userNoNameMap = {};

  IssuePostPage({required this.groupNo, required this.userNo, required this.userNoNameMap});

  @override
  State<IssuePostPage> createState() => _IssuePostPageState(groupNo, userNo, userNoNameMap);
}

class _IssuePostPageState extends State<IssuePostPage> {
  
  final int groupNo;
  final int userNo;
  Map<int, String> userNoNameMap = {};

  _IssuePostPageState(this.groupNo, this.userNo, this.userNoNameMap);

  TextEditingController titleController = TextEditingController();
  TextEditingController contextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Widget issuePost() {
      Widget issuePostWidget = Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 20.0, right: 20.0),
        child: Container(
          width: 400,
          height: 650,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: '제목을 입력하세요',
                        border: InputBorder.none,),
                      keyboardType: TextInputType.text,
                    ),
                  )
                ),
                SizedBox(height: 20,),
                SizedBox(height: 450,
                  child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: contextController,
                    decoration: InputDecoration(
                      hintText: '의견을 공유하세요',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                ),
                IconButton(
                  onPressed: () async {
                    if (titleController.text == "" || contextController.text == ""){
                      return;
                    }
                    print("post button");
                    int statusCode = await IssueAPISystem.postIssueEntity(titleController.text, contextController.text, userNo, groupNo);
                    if (statusCode == 200) {
                      Navigator.pop(context);
                    }
                  }, 
                  alignment: Alignment.bottomRight,
                  color: colorScheme.color3,
                  iconSize: 30,
                  icon: Icon(Icons.send_rounded))
              ]
            )
          )
        )
      );
      return issuePostWidget;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("WRITING ISSUE", style: TextStyle(color: Colors.white)),
        elevation: 0.0,
        backgroundColor: colorScheme.color4,
        centerTitle: true,
      ),
      body: GestureDetector(     
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView( 
          child: issuePost(),
        )
      ),
    );

  }
}