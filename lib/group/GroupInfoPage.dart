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
  final GroupEntity groupEntity;

  GroupInfoPage({ 
    required this.groupEntity,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState(groupEntity);
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  final GroupEntity groupEntity;
  late BookEntity bookEntity;

  List<UserEntity> userList = [];
  List<GroupUserEntity> groupUserList = [];
  Map<int, String> userNoNameMap = {};

  _GroupInfoPageState(this.groupEntity);
  

  Future<bool> loadGroupUser() async{
    bookEntity = await BookAPISystem.getBookEntity(groupEntity.groupBookNo);
    print(groupEntity.groupNo);
    if(userList.isEmpty){
      userList = await UserAPISystem.getGroupUserList(groupEntity.groupNo);
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
      Widget bookWidget = Padding(
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 180,
            height: 270,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Image(
              image: NetworkImage(bookEntity.bookImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
      return bookWidget;
    }

    Future<Widget> getGroupDetail() async {
      bool isFinished = await loadGroupUser();
      int toNow = DateTime.now().difference(groupEntity.groupStartDate).inDays + 1;
      Widget groupWidget = Padding(
        padding: const EdgeInsets.all(20.0),
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
                  SizedBox(height: 10,),
                  Text(
                    "독서 시작일",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  SizedBox(height: 10,),
                  Row(children: [
                    Text(
                    DateFormat('yyyy년 M월 d일').format(groupEntity.groupStartDate),
                    style: TextStyle(
                      fontSize: 16.0,
                    )),
                    SizedBox(width: 5,),
                    Text(
                    "("+toNow.toString()+"일째)",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: colorScheme.color3,
                    )),
                  ],
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "독서 모임 구성원",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  SizedBox(height: 10,),
                  Row(children: [
                    Text(
                      userList[0].userName,
                      style: TextStyle(
                      fontSize: 16.0,
                      ),
                    ),
                    for(int i=1; i<userList.length; i++)
                      Text(", "+userList[i].userName,
                      style: TextStyle(
                      fontSize: 16.0,
                    )),
                  ],),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
        return groupWidget;
    }

    Future<List<Widget>> getUserList() async{
      bool isFinished = await loadGroupUser();
      
      for(int i = groupUserList.length; i < userList.length; i++){
        int userNo = userList[i].userNo;
        print("GROUP NO : " + userNo.toString());
        GroupUserEntity groupUserEntity = await UserAPISystem.getGroupUserEntity(userNo, groupEntity.groupNo);
        groupUserList.add(groupUserEntity);
      }
      List<Widget> widgetList = [];
      
      for(int i = 0; i < userList.length; i++){
        Widget widget = Container(//Transform.translate(
          //offset: Offset(-25*i.toDouble(), 0),
          child: SizedBox(
            width: 130,
            height: 130,
            child: Column(
              children :[
                SizedBox(
                  height: 110,
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
            alignment: Alignment.center,
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
                  return SizedBox(
                    child: snapshot.data,
                  );
                }
              }
            )
          ),
          Container(
            child: FutureBuilder(
              future: getGroupDetail(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData == false || snapshot.hasError){
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator()
                  );
                }else{
                  return SizedBox(
                      child: snapshot.data,
                    );
                }
              }
            )
          ),
          /*
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
          */
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0),
            child: SizedBox(
              child: Text(
                "독서 진행 상황",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            height: 130.0,
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.color3,
                ),
              ),
              IconButton(onPressed: (){
                onIssuePressed(groupEntity.groupNo, userNoNameMap);
                },
               icon: Icon(Icons.send),
              ),
              SizedBox(width: 10,),
            ],
          )
        ]
      ),
    );
  }
}