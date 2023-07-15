import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/db/GroupEntity.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:checktrack/db/GroupUserEntity.dart';
import 'package:checktrack/db/BookEntity.dart';
import 'package:checktrack/group/IssuePage.dart';



class GroupInfoPage extends StatefulWidget {
  final int groupNo;

  GroupInfoPage({ 
    required this.groupNo,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState(groupNo);
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  late GroupEntity groupEntity;
  late BookEntity bookEntity;
  final int groupNo;

  List<UserEntity> userList = [];
  List<GroupUserEntity> groupUserList = [];
  Map<int, String> userNoNameMap = {};

  _GroupInfoPageState(this.groupNo);
  

  Future<bool> loadGroupUser() async{
    groupEntity = await GroupAPISystem.getGroupEntity(groupNo);
    bookEntity = await BookAPISystem.getBookEntity(groupEntity.groupBookNo);
    print(groupEntity);
    if(userList.isEmpty){
      userList = await UserAPISystem.getGroupUserList(groupNo);
      for(int i=0; i<userList.length; i++){
        userNoNameMap[userList[i].userNo] = userList[i].userName;
      }
    }
    print("LOADED GROUP INFORMATION");
    return true;
  }

  

  @override
  Widget build(BuildContext context) {

    void onIssuePressed(mGroupNo, mUserMap) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => IssuePage(groupNo: mGroupNo, userNoNameMap: mUserMap,)));
    }

    SfLinearGauge makeDayGauge(){
      int period = groupEntity.groupEndDate.difference(groupEntity.groupStartDate).inDays;
      debugPrint(period.toString());
      int toNow = DateTime.now().difference(groupEntity.groupStartDate).inDays;
      debugPrint(toNow.toString());
      double percent = toNow / period * 100;
      debugPrint(percent.toString());
      return SfLinearGauge(
        barPointers: [ 
          LinearBarPointer(
            value: percent,
            // Changed the thickness to make the curve visible
            thickness: 10,
            //Updated the edge style as curve at end position
            edgeStyle: LinearEdgeStyle.endCurve,
            shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [colorScheme.color3, colorScheme.color4])
                    .createShader(bounds)
          )
        ],
        showLabels: false,          
        showTicks: false,
      );
    }

    SfRadialGauge makeGauge(int userPage) {
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
            ],
            pointers: <GaugePointer>[
              RangePointer(
                value: userPage.toDouble() + 12,
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
            ]
          ),
        ],
      );
    }

    Future<Widget> getBookDetail() async{
      bool isFinished = await loadGroupUser();
      return Column();
    }

    Future<Widget> getDayGraph() async{
      bool isFinished = await loadGroupUser();
      return 
        Column(
          children:[ 
            SizedBox(height: 10.0, ),
            Row(
              children: [
                Text(
                    DateFormat('MM/dd').format(groupEntity.groupStartDate),
                    style: TextStyle(
                    fontSize: 15.0,
                    )
                ),
                Spacer(),
                Text(
                    DateFormat('MM/dd').format(groupEntity.groupEndDate),
                    style: TextStyle(
                    fontSize: 15.0,
                    )
                ),
            ],),
            SizedBox(height: 10.0, ),
            makeDayGauge(),
          ]
        );
    }


    Future<List<Widget>> getUserList() async{
      bool isFinished = await loadGroupUser();
      
      for(int i = groupUserList.length; i < userList.length; i++){
        int userNo = userList[i].userNo;
        print("GROUP NO : " + userNo.toString());
        GroupUserEntity groupUserEntity = await UserAPISystem.getGroupUserEntity(userNo, groupNo);
        groupUserList.add(groupUserEntity);
      }
      List<Widget> widgetList = [];
      
      for(int i = 0; i < userList.length; i++){
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
                  style: TextStyle(fontSize: 14.0)
                ),
              ]  
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            height: 200.0,
            width : MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: getBookDetail(),
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
                    child: SizedBox(
                      height: 200,
                      child: snapshot.data,
                    ),
                  );
                }
              }
            )
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder(
              future: getDayGraph(),
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
                    child: SizedBox(
                      height: 50,
                      child: snapshot.data,),
                  );
                }
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, left: 20.0),
            child: SizedBox(
              child: Text(
                "Group Member",
                textAlign: TextAlign.start,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("독서 내용 공유하기",
              ),
              IconButton(onPressed: (){
                onIssuePressed(groupNo, userNoNameMap);
                },
               icon: Icon(Icons.send),
              ),

            ],
          )
        ]
      ),
    );
  }
}