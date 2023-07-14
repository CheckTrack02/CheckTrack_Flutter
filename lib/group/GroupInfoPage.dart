import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/db/GroupEntity.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/db/GroupUserEntity.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:checktrack/db/BookEntity.dart';
import 'package:checktrack/db/IssueEntity.dart';


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
    //loadGroupUser();
  }

  late GroupEntity groupEntity;
  late BookEntity bookEntity;
  final int groupNo;

  List<UserEntity> userList = [];
  List<GroupUserEntity> groupUserList = [];
  List<IssueEntity> issueList = [];
  Map<int, String> userNoNameMap = {};
  

  Future<bool> loadGroupUser() async{
    groupEntity = await GroupAPISystem.getGroupEntity(groupNo);
    bookEntity = await BookAPISystem.getBookEntity(groupEntity.groupBookNo);
    //print(groupEntity);
    if(userList.isEmpty){
      userList = await UserAPISystem.getGroupUserList(groupNo);
      for(int i=0; i<userList.length; i++){
        userNoNameMap[userList[i].userNo] = userList[i].userName;
      }
    }

    if(issueList.isEmpty){
      issueList = await IssueAPISystem.getGroupIssueList(groupNo);
    }

    print("LOADED GROUP INFORMATION");
    
    // TEST
    //for(int i=0; i<userList.length; i++){
    //  print(userList[i].userName + " " + userList[i].userNo.toString());
    //}
    // TEST
    return true;
  }

  

  @override
  Widget build(BuildContext context) {

    SfRadialGauge makeGauge(int userPage){
      int bookPage = bookEntity.bookPageNum;
      bool isCardView = false;
      double _markerValue = 100.0;
      return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            radiusFactor: 1,
            maximum: bookPage.toDouble(),
            axisLineStyle: const AxisLineStyle(
                cornerStyle: CornerStyle.startCurve, thickness: 5),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 90,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(userPage.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          'pages',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 9),
                        ),
                      )
                    ],
                  )),
              /*GaugeAnnotation(
                angle: 124,
                positionFactor: 1.1,
                widget:
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text('0', style: TextStyle(fontSize: 8)),
                    ),
              ),
              GaugeAnnotation(
                angle: 54,
                positionFactor: 1.1,
                widget: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(bookPage.toString(),
                      style: TextStyle(fontSize: 8)),
                ),
              ),*/
            ],
            pointers: <GaugePointer>[
              RangePointer(
                value: userPage.toDouble()+12,
                width: 5,
                pointerOffset: 0,
                cornerStyle: CornerStyle.bothCurve,
                color: colorScheme.color1,
                gradient: SweepGradient(
                    colors: <Color>[colorScheme.color3, colorScheme.color4],
                    stops: <double>[0.25, 0.75]),
              ),
              MarkerPointer(
                value: userPage.toDouble(),
                color: Colors.brown,
                markerType: MarkerType.circle,
              ),
            ]),
      ],
    ); 
    }


    Future<List<Widget>> getUserList() async{
      bool isFinished = await loadGroupUser();
      
      
      for(int i=groupUserList.length; i<userList.length; i++){
        int userNo = userList[i].userNo;
        print("GROUP NO : " + userNo.toString());
        GroupUserEntity groupUserEntity = await UserAPISystem.getGroupUserEntity(userNo, groupNo);
        groupUserList.add(groupUserEntity);
      }
      List<Widget> widgetList = [];
      
      for(int i=0; i<userList.length; i++){
        Widget widget = Container(//Transform.translate(
          //offset: Offset(-25*i.toDouble(), 0),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Column(
              children :[
                SizedBox(
                  height: 100,
                  width: 100,
                  child: makeGauge(groupUserList[i].userPage),
                ),
                Text(
                  userList[i].userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.0)
                ),
              ]  
            ),
          ),
        );
        widgetList.add(widget);
      }


      return widgetList;
    }

    Future<List<Widget>> getIssueList() async{
      bool isFinished = await loadGroupUser();
      List<Widget> widgetList = [];
      for(int i=0; i<issueList.length; i++){
        Widget widget = SizedBox(
          child: Row(
            children: [
              Column(
                children:[
                  Text(
                    issueList[i].issueTitle,
                    style: TextStyle(
                      fontSize: 30.0,
                    )
                  ),
                  Text(
                    userNoNameMap[issueList[i].issueUserNo]!,
                    style: TextStyle(
                      fontSize: 10.0,
                    )
                  ),
                ]
              ),
              Text(
                issueList[i].issueDate.toString(),
                style: TextStyle(
                  fontSize: 20.0,
                )
              ),
            ],
          ),
        );
        widgetList.add(widget);
      }
      return widgetList;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Club'),
        elevation: 0.0,
        backgroundColor: colorScheme.color6,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
            child: SizedBox(
              child: Text(
                "모임 참가자",
                style: TextStyle(
                  fontSize: 20.0,
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            height: 200.0,
            width : MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: getUserList(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData == false || snapshot.hasError){
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator()
                  );
                }else{
                  return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.toList(),
                    ),
                  );
                }
              }
            )
          ),
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
          )
        ]
      ),
    );
  }
}