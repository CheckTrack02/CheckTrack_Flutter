import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/db/IssueEntity.dart';
import 'package:checktrack/group/CommentPage.dart';

class IssuePage extends StatefulWidget {
  final int groupNo;
  Map<int, String> userNoNameMap = {};

  IssuePage({required this.groupNo, required this.userNoNameMap});

  @override
  State<IssuePage> createState() => _IssuePageState(groupNo, userNoNameMap);
}

class _IssuePageState extends State<IssuePage> {
  
  late List<IssueEntity> issueList = [];
  final int groupNo;
  Map<int, String> userNoNameMap = {};

  _IssuePageState(this.groupNo, this.userNoNameMap);

  Future<bool> loadIssueList() async{
    issueList = await IssueAPISystem.getGroupIssueList(groupNo);

    print("LOADED ISSUE INFORMATION");
    return true;
  }


  @override
  Widget build(BuildContext context) {

    void onCommentPressed(mIssue, mUserMap) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CommentPage(issue: mIssue, userNoNameMap: mUserMap,)));
    }

    Future<List<Widget>> getIssueList() async{
      bool isFinished = await loadIssueList();
      List<Widget> widgetList = [];
      for(int i=0; i<issueList.length; i++){
        Widget widget = Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
              onCommentPressed(issueList[i], userNoNameMap);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
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
                          userNoNameMap[issueList[i].issueUserNo]!,
                          style: TextStyle(
                            fontSize: 17.0,
                          )
                        ),
                      ],
                    ),
                    SizedBox(height:20, ),
                    Text(
                      issueList[i].issueTitle,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 17.0,
                      )
                    ),
                    SizedBox(height:10, ),
                    Text(
                      issueList[i].issueContext,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15.0,
                      )
                    ),
                    SizedBox(height:35, ),
                    Row(
                      children:[
                        Text(
                            DateFormat('yyyy-MM-dd').format(issueList[i].issueDate),
                            style: TextStyle(
                              fontSize: 13.0,
                              color: colorScheme.color3,
                            )
                        ),
                        Spacer(),
                        Icon(Icons.comment),
                        SizedBox(width: 10,),
                        Text(
                            issueList[i].issueCommentNum.toString(),
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
          )
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
            Expanded(
            child: FutureBuilder(
              future: getIssueList(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData == false || snapshot.hasError){
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  );
                }else{
                  return ListView(
                    children: snapshot.data.toList(),
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
