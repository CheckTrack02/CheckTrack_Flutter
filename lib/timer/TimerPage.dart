import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/db/BookEntity.dart';
import 'package:checktrack/timer/SelectBookPage.dart';
import 'package:checktrack/system/SocketSystem.dart';
import 'dart:async';
import 'dart:ui';
import 'package:checktrack/db/UserBookEntity.dart';
import 'package:checktrack/system/TimerSystem.dart';
import 'dart:math';

class TimerPage extends StatefulWidget {
  BookEntity bookEntity;
  

  TimerPage({required this.bookEntity});
  @override
  State<TimerPage> createState() => _TimerPageState(bookEntity: bookEntity);
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin, WidgetsBindingObserver{
  BookEntity bookEntity;
  late UserBookEntity userBookEntity;
  bool isChangingText = false;

  

  void loadUserBookEntity() async{
    userBookEntity = await UserBookAPISystem.getUserBookEntity(APISystem.getUserEntity().userNo, bookEntity.bookNo);
    TimerSystem.currentTime = userBookEntity.userTime;
    TimerSystem.currentPage = userBookEntity.userPage;
    TimerSystem.recentTime = userBookEntity.userTime;
    TimerSystem.recentPage = userBookEntity.userPage;
    
  }
  
  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    TimerSystem.setGroupUserList();
    super.initState();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.paused || state == AppLifecycleState.detached){
      finishTimer();
    }
    super.didChangeAppLifecycleState(state);
  }

  _TimerPageState({required this.bookEntity}){
    SocketSystem.initSocket();
    TimerSystem.isTimerStart = true;
    TimerSystem.bookEntity = bookEntity;
    TimerSystem.currentDuration = 0;
    TimerSystem.currentTime = 0;
    TimerSystem.recentTime = 0;
    TimerSystem.recentPage = 0;
    TimerSystem.currentPage = 0;
    SocketSystem.startTimer(bookEntity.bookNo);
    startTimer();
    loadUserBookEntity();
  }

  TextEditingController textEditingController = TextEditingController();
  late TabController _tabController;
  late Timer _timer;

  void startTimer(){
    print("TIMER START");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      if(mounted){
        setState((){
          TimerSystem.currentDuration++;
          TimerSystem.currentTime++;
          TimerSystem.checkUpdateList();
          if(TimerSystem.recentTime!=0){
            TimerSystem.currentPage = (TimerSystem.currentTime * TimerSystem.recentPage) ~/ TimerSystem.recentTime;
            TimerSystem.currentPage = min(TimerSystem.currentPage, bookEntity.bookPageNum);
            //print(TimerSystem.currentPage);
            if(!isChangingText){
              textEditingController.text = TimerSystem.currentPage.toString();
            }
          }
        });
      }
    });
  }

  void updateBookPage(String bookPageString){
    isChangingText = false;
    int? bookPage = int.tryParse(bookPageString);
    if(bookPage!=null){
      if(bookPage <= bookEntity.bookPageNum){
        TimerSystem.recentPage = bookPage;
        TimerSystem.recentTime = TimerSystem.currentTime;
        SocketSystem.updateBookPage(TimerSystem.recentPage, TimerSystem.recentTime);
        setState(() {
          TimerSystem.currentPage = bookPage;
        });
      }
    }
  }

  @override dispose(){
    textEditingController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void finishTimer(){
    print("TIMER FINISH");
    _timer.cancel();
    Navigator.pop(context, "finished");
  }

  late Widget groupUserListWidget, allUserListWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Timer'),
        elevation: 0.0,
        backgroundColor: colorScheme.color6,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children:[
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 50, right: 50),
                child: Row(

                  children:[
                    Text(
                      "${(TimerSystem.currentDuration/3600%60).toInt().toString().padLeft(2, "0")}:${(TimerSystem.currentDuration/60%60).toInt().toString().padLeft(2, "0")}:${(TimerSystem.currentDuration%60).toInt().toString().padLeft(2, "0")}", 
                      style: TextStyle(fontSize: 50, color: colorScheme.color6),
                    ),
                    Spacer(),
                    Container(
                      decoration: const ShapeDecoration(
                        color: colorScheme.color6,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.pause),
                        color: colorScheme.color1,
                        onPressed: () {
                          finishTimer();
                        },
                      ),
                    )
                  ]
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50, top: 20),
              child: Row(
                children:[
                  Text(
                    "Total", 
                    style: TextStyle(fontSize: 25, color: colorScheme.color4),
                  ),
                  Spacer(),
                  Text(
                    "${(TimerSystem.currentTime/3600%60).toInt().toString().padLeft(2, "0")}:${(TimerSystem.currentTime/60%60).toInt().toString().padLeft(2, "0")}:${(TimerSystem.currentTime%60).toInt().toString().padLeft(2, "0")}", 
                    style: TextStyle(fontSize: 25, color: colorScheme.color4),
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50, top: 20),
              child: SizedBox(
                height: 40.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children:[
                    Text(
                      "Page", 
                      style: TextStyle(fontSize: 25, color: colorScheme.color4),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 30,
                      width: 70.0,
                      child: TextField(
                        maxLength: 4,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          counterStyle: TextStyle(height: double.minPositive,),
                          counterText: "",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom:12),
                        ),
                        controller: textEditingController,
                        onTap:(){
                          isChangingText = true;
                        },
                        onSubmitted: (text){
                          updateBookPage(text);
                        },
                        style: TextStyle(fontSize: 25, color: colorScheme.color4),
                      ),
                    ),
                    Text(
                      "pg",
                      style: TextStyle(fontSize: 25, color: colorScheme.color4),
                    )
                  ]
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 30),
              child: TabBar(
                tabs: [
                  Container(
                    height : 40,
                    alignment: Alignment.center,
                    child: Text(
                      '그룹',
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '전체'
                    )
                  )
                ],
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      colorScheme.color4,
                      colorScheme.color4,
                    ],
                  ),
                ),
                labelColor: colorScheme.color1,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: getGroupUserListWidget(),
                  ),
                  /*FutureBuilder(
                    future: getGroupUserListWidget(),
                    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot){
                      if(snapshot.hasData){
                        return snapshot.data!;
                      }
                      else{
                        return Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: getAllUserListWidget(),
                  ),
                  /*FutureBuilder(
                    future: getAllUserListWidget(),
                    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot){
                      if(snapshot.hasData){
                        return snapshot.data!;
                      }
                      else{
                        return Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  )*/
                ]
              )
            )
          ] 
        )
      )
    );
  }

  bool isInitGroupUserListWidget = false;
  Widget getGroupUserListWidget(){
    //print("GET GROUP USER LIST WIDGET");
    List<Widget> columnWidget = [];
    List<Widget> rowWidget = [];
    TimerSystem.groupUserMap.forEach((key, value){
      String userName = key;
      int userTime = value['userTime'];
      int userPage = value['userPage'];
      bool isInList = value['isInList'];
      //print("$userName ${userTime.toString()} ${userPage.toString()} ${isInList.toString()}");
      Color userColor = colorScheme.color6;
      if(!isInList){
        userColor = colorScheme.color5;
      }else{
        //print("USER NAME : $userName");
        userTime = value['recentUserTime'] + TimerSystem.currentDuration;
        userPage = min(bookEntity.bookPageNum, value['recentUserPage'] + (userPage * TimerSystem.currentDuration) ~/ userTime);

        /* Percentage 따라서 색 결정
        int percentage = (100 * userPage) ~/ bookEntity.bookPageNum;
        */
      } 
      Widget widget = SizedBox(
        width : 70,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.auto_stories, color: userColor),
              onPressed: null,
            ),
            Text(
              userName,
              style: TextStyle(fontSize: 20, color: userColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Text(
                TimerSystem.timeToString(userTime),
                style: TextStyle(fontSize: 15, color: userColor),
              ),
            ),
            Text(
              "$userPage pg",
              style: TextStyle(fontSize: 15, color: userColor),
            )
          ]
        ),
      );
      rowWidget.add(widget);
      if(rowWidget.length==4){
        columnWidget.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowWidget
          )
        );
        rowWidget = [];
      }
    });
    if(rowWidget.isNotEmpty){
      while(rowWidget.length<4){
        rowWidget.add(SizedBox(width: 70, height: 150));
      }
      columnWidget.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowWidget
        )
      );
    }
    groupUserListWidget = ListView(children: columnWidget);
    return groupUserListWidget;
  }

  Widget getAllUserListWidget(){
    List<Widget> columnWidget = [];
    List<Widget> rowWidget = [];
    TimerSystem.roomUserList.forEach((key, value){
      String userName = key;
      int userTime = value['userTime'];
      int userPage = value['userPage'];
      Color userColor = colorScheme.color6;
      userPage = min(bookEntity.bookPageNum, value['recentUserPage'] + (userPage * TimerSystem.currentDuration) ~/ userTime);
      userTime = value['recentUserTime'] + TimerSystem.currentDuration;
      //print(userTime.toString() + " " + userPage.toString());
      Widget widget = SizedBox(
        width : 70,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.auto_stories, color: userColor),
              onPressed: null,
            ),
            Text(
              userName,
              style: TextStyle(fontSize: 20, color: userColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Text(
                TimerSystem.timeToString(userTime),
                style: TextStyle(fontSize: 15, color: userColor),
              ),
            ),
            Text(
              "$userPage pg",
              style: TextStyle(fontSize: 15, color: userColor),
            )
          ]
        ),
      );
      rowWidget.add(widget);
      if(rowWidget.length==4){
        columnWidget.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowWidget
          )
        );
        rowWidget = [];
      }
    });
    if(rowWidget.length>0){
      while(rowWidget.length<4){
        rowWidget.add(SizedBox(width: 70, height: 150));
      }
      columnWidget.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowWidget
        )
      );
    }
    allUserListWidget = ListView(children: columnWidget);
    return allUserListWidget;
  }


}
