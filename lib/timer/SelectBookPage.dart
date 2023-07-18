import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/db/BookEntity.dart';


class SelectBookPage extends StatefulWidget {

  SelectBookPage();



  @override
  State<SelectBookPage> createState() => _SelectBookPageState();
}

class _SelectBookPageState extends State<SelectBookPage> with TickerProviderStateMixin{
  late TabController _tabController;

  _SelectBookPageState();
  List<BookEntity> readingBookList = [], willReadBookList = [];
  late Widget readingBookListWidget, willReadBookListWidget;
  @override
  void initState(){
    _tabController = TabController(
      length : 2,
      vsync: this,
    );
    super.initState();
  }
      
  void onTapBook(BookEntity bookEntity){
    Navigator.pop(context, bookEntity);
  }

  late UserEntity myUserEntity;

  Future<Widget> getReadingBookListWidget() async{
    myUserEntity = APISystem.getUserEntity();
    if(readingBookList.isEmpty){
      readingBookList = await BookAPISystem.getReadingBookList(myUserEntity.userNo);
      List<Widget> widgetColumn = [];
      for(int i=0; i<readingBookList.length; i+=3){
        List<Widget> widgetRow = [];
        for(int j=i; j<i+3; j++){
          if(j>=readingBookList.length){
            widgetRow.add(SizedBox(width: 100));
          }else{
            widgetRow.add(SizedBox(
              width: 100,
              child: Column(children: [
                GestureDetector(
                    onTap: () {
                      onTapBook(readingBookList[j]);
                    },
                    child: Image(
                      image: NetworkImage(readingBookList[j].bookImage),
                      width: 100,
                      height: 120,
                    )),
                SizedBox(
                  height: 15,
                ),
                Text(
                  readingBookList[j].bookName,
                  maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  style: TextStyle(),
                ),
              ]),
            ));
          }
        }
        widgetColumn.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widgetRow
          )
        );
      }
      readingBookListWidget = 
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: widgetColumn),
        );
    }
    return readingBookListWidget;
  }

  Future<Widget> getWillReadBookListWidget() async{
    myUserEntity = APISystem.getUserEntity();
    if(willReadBookList.isEmpty){
      willReadBookList = await BookAPISystem.getWillReadBookList(myUserEntity.userNo);
      List<Widget> widgetColumn = [];
      for(int i=0; i<willReadBookList.length; i+=3){
        List<Widget> widgetRow = [];
        for(int j=i; j<i+3; j++){
          if(j>=willReadBookList.length){
            widgetRow.add(SizedBox(width: 100));
          }else{
            widgetRow.add(SizedBox(
              width: 100,
              child: Column(children: [
                GestureDetector(
                    onTap: () {
                      onTapBook(willReadBookList[j]);
                    },
                    child: Image(
                      image: NetworkImage(willReadBookList[j].bookImage),
                      width: 100,
                      height: 120,
                    )),
                SizedBox(
                  height: 15,
                ),
                Text(
                  willReadBookList[j].bookName,
                  maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  style: TextStyle(),
                ),
              ]),
            ));
          }
        }
        widgetColumn.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widgetRow
          )
        );
      }
      for(int i=0; i<willReadBookList.length; i++){
        print(willReadBookList[i].bookName);
      }
      willReadBookListWidget = Padding(
        padding: const EdgeInsets.all(15.0),

        child: Column(children: widgetColumn)
      );
    }
    return willReadBookListWidget;
  }

  //BookEntity bookEntity = getBookEntity()

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Book'),
        elevation: 0.0,
        backgroundColor: colorScheme.color6,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: TabBar(
              tabs: [
                Container(
                  height : 40,
                  alignment: Alignment.center,
                  child: Text(
                    '읽고 있는 책',
                  ),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    '읽을 예정인 책'
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
                  future: getReadingBookListWidget(),
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
                  },
                ),
                FutureBuilder(
                  future: getWillReadBookListWidget(),
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
                  },
                ),
              ],
            ),
          ),
        ]
      )
    );
  }
}