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

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
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
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  _TimerPageState({required this.bookEntity}){
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
          if(TimerSystem.recentTime!=0){
            TimerSystem.currentPage = (TimerSystem.currentTime * TimerSystem.recentPage) ~/ TimerSystem.recentTime;
            TimerSystem.currentPage = min(TimerSystem.currentPage, bookEntity.bookPageNum);
            print(TimerSystem.currentPage);
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
        setState(() {
          TimerSystem.currentPage = bookPage;
        });
      }
    }
  }

  @override dispose(){
    textEditingController.dispose();
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
          color: colorScheme.color1,
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
                height: 30.0,
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
                      colorScheme.color2,
                      colorScheme.color5,
                    ],
                  ),
                ),
                labelColor: Colors.brown,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FutureBuilder(
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
                  ),
                  FutureBuilder(
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
                  )
                ]
              )
            )
          ] 
        )
      )
    );
  }

  Future<Widget> getGroupUserListWidget() async{
    groupUserListWidget = Column();
    return groupUserListWidget;
  }

  Future<Widget> getAllUserListWidget() async{
    allUserListWidget = Column();
    return allUserListWidget;
  }

  
}
