import 'package:checktrack/db/GroupEntity.dart';
import 'package:checktrack/group/GroupInfoPage.dart';
import 'package:checktrack/group/GroupAddPage.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';

class GroupPage extends StatefulWidget {
  final int userNo;
  final VoidCallback? onFlip;
  GroupPage({required this.userNo, required this.onFlip});

  @override
  State<GroupPage> createState() => _GroupPageState(userNo);
}

class _GroupPageState extends State<GroupPage> {
  _GroupPageState(this.userNo) {}

  final int userNo;
  List<GroupEntity> groupList = [];
  List<String> bookImageList = [];

  Future<bool> loadGroupList() async {
    bookImageList.clear();
    groupList = await GroupAPISystem.getUserGroupList(userNo);
    print(groupList);
    for (GroupEntity item in groupList) {
      final response = await BookAPISystem.getBookEntity(item.groupBookNo);
      print(item.groupBookNo.toString());
      print(response.bookImage);
      bookImageList.add(response.bookImage);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    void onAddPressed(mUserNo) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => GroupAddPage(userNo: mUserNo)));
      setState(() { });
    }

    Future<List<Widget>> makeGrid() async {
      bool isFinished = await loadGroupList();
      List<Widget> gridBooks = [];

      void onGroupPressed(mGroup, mUserNo) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => GroupInfoPage(groupEntity: mGroup, userNo: mUserNo)));
      }


      for (int i = 0; i < groupList.length; i += 3) {
        List<Widget> row = [];
        for (int j = i; j < i + 3; j++) {
          if (j >= groupList.length) {
            row.add(SizedBox(
              width: 100,
            ));
          }
          else {
            row.add(Column(children: [
              GestureDetector(
                  onTap: () {
                    onGroupPressed(groupList[j], userNo);
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group_add),
        backgroundColor: colorScheme.color3,
        focusColor: colorScheme.color1,
        onPressed: () { onAddPressed(this.userNo); },
      ),    
    );
  }
}
