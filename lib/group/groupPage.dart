import 'package:checktrack/db/GroupEntity.dart';
import 'package:checktrack/group/GroupInfoPage.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';

class GroupPage extends StatefulWidget {
  final int userNo;
  GroupPage({required this.userNo});

  @override
  State<GroupPage> createState() => _GroupPageState(userNo);
}

class _GroupPageState extends State<GroupPage> {
  _GroupPageState(this.userNo) {}

  final int userNo;
  List<GroupEntity> groupList = [];
  List<String> bookImageList = [];

  Future<bool> loadGroupList() async {
    groupList = await GroupAPISystem.getUserGroupList(userNo);
    for (GroupEntity item in groupList) {
      print(item.groupNo);
      final response = await BookAPISystem.getBookEntity(item.groupBookNo);
      bookImageList.add(response.bookImage);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    Future<List<Widget>> makeGrid() async {
      bool isFinished = await loadGroupList();
      List<Widget> gridBooks = [];

      void onGroupPressed(mGroupNo) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => GroupInfoPage(groupNo: mGroupNo)));
      }

      for (int i = 0; i < groupList.length; i += 3) {
        List<Widget> row = [];
        for (int j = i; j < i + 3; j++) {
          if (j >= bookImageList.length) {
            row.add(SizedBox(
              width: 100,
            ));
          } 
          else {
            row.add(Column(children: [
              GestureDetector(
                  onTap: () {
                    onGroupPressed(3);
                  },
                  child: Image(
                    image: NetworkImage(bookImageList[j]),
                    width: 100,
                    height: 120,
                  )),
              SizedBox(
                height: 15,
              ),
              Text(
                groupList[j].groupName,
                style: TextStyle(),
              ),
            ]));
          }
        }
        gridBooks.add(Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [...row],
          ),
        ));
      }

      return gridBooks;
    }

    

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colorScheme.color4,
          title: Row(
            children: [
              Icon(
                Icons.people,
              ),
              SizedBox(
                width: 15,
              ),
              Text("READING GROUP", style: TextStyle(color: Colors.white)),
            ],
          )),
      body: FutureBuilder(
              future: makeGrid(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData == false || snapshot.hasError){
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator()
                  );
                }else{
                  return Column(
                    children: snapshot.data.toList(),
                  );
                }
              }
            )
    );
  }
}
