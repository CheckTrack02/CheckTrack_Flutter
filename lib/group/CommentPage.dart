import 'package:checktrack/db/CommentEntity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/db/IssueEntity.dart';

class CommentPage extends StatefulWidget {
  final IssueEntity issue;
  Map<int, String> userNoNameMap = {};

  CommentPage({required this.issue, required this.userNoNameMap});

  @override
  State<CommentPage> createState() => _CommentPageState(issue, userNoNameMap);
}

class _CommentPageState extends State<CommentPage> {
  
  late List<CommentEntity> commentList = [];
  final IssueEntity issue;
  Map<int, String> userNoNameMap = {};

  _CommentPageState(this.issue, this.userNoNameMap);

  Future<bool> loadCommentList() async{
    commentList = await CommentAPISystem.getIssueCommentList(issue.issueNo);
    
    print("LOADED COMMENT INFORMATION");
    return true;
  }


  @override
  Widget build(BuildContext context) {

    Widget issueDetail() {
      Widget issueWidget = Padding(
        padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle,
                        size: 30,),
                      SizedBox(width: 10,),
                      Text(
                        userNoNameMap[issue.issueUserNo]!,
                        style: TextStyle(
                          fontSize: 17.0,
                        )
                      ),
                    ],
                  ),
                  SizedBox(height:20, ),
                  Text(
                    issue.issueTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 17.0,
                    )
                  ),
                  SizedBox(height:10, ),
                  Text(
                    issue.issueContext,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15.0,
                    )
                  ),
                  SizedBox(height:35, ),
                  Row(
                    children:[
                      Text(
                          DateFormat('yyyy-MM-dd').format(issue.issueDate),
                          style: TextStyle(
                            fontSize: 13.0,
                            color: colorScheme.color3,
                          )
                      ),
                      Spacer(),
                      Icon(Icons.comment),
                      SizedBox(width: 10,),
                      Text(
                          issue.issueCommentNum.toString(),
                          style: TextStyle(
                            fontSize: 13.0,
                            color: colorScheme.color3,
                          )
                      ),
                    ]
                  ),
                ],
              ),
            ),
          ),
        );
        return issueWidget;
    }

    Future<List<Widget>> getCommentList() async{
      bool isFinished = await loadCommentList();
      List<Widget> widgetList = [];
      for(int i=0; i<commentList.length; i++){
        Widget widget = Padding(
          padding: const EdgeInsets.only(left:15.0, right:15.0, top: 10.0),
          child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle,
                        size: 25,),
                      SizedBox(width: 10,),
                      Text(
                        userNoNameMap[commentList[i].commentUserNo]!,
                        style: TextStyle(
                          fontSize: 15.0,
                        )
                      ),
                      Spacer(),
                      Text(
                          DateFormat('yyyy-MM-dd').format(commentList[i].commentDate),
                          style: TextStyle(
                            fontSize: 13.0,
                            color: colorScheme.color3,
                          )
                      ),
                    ],
                  ),
                  SizedBox(height:20, ),
                  Text(
                    commentList[i].commentText,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15.0,
                    )
                  ),
                  SizedBox(height:20, ),
                  Divider(),
                ],
              ),
            ),
        );
        widgetList.add(widget);
      }
      return widgetList;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("READING JOURNAL", style: TextStyle(color: Colors.white)),
          elevation: 0.0,
          backgroundColor: colorScheme.color4,
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            issueDetail(),
            SizedBox(height: 20,),
            Expanded(
            child: FutureBuilder(
              future: getCommentList(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData == false || snapshot.hasError){
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  );
                }else{
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ListView(
                          children: snapshot.data.toList(),
                        ),
                      ),
                    ),
                  );
                }
              }
            )
          ),
          ],
        ),
    );
  }
}
