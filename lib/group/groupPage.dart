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
      final response = await BookAPISystem.getBookEntity(item.groupBookNo);
      bookImageList.add(response.bookImage);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<String> books = [
      'assets/images/book1.jpg',
      'assets/images/book2.jpg',
      'assets/images/book3.jpg',
      'assets/images/book4.jpg'
    ];
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colorScheme.color6,
          title: Row(
            children: [
              Icon(
                Icons.people,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Reading Group", style: TextStyle(color: Colors.white)),
            ],
          )),
      body: makeGrid(context, groupList, bookImageList),
    );
  }
}

Column makeGrid(
    BuildContext context, List<GroupEntity> groups, List<String> books) {
  List<Widget> gridBooks = [];

  void onGroupPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => GroupInfoPage(groupNo: 3)));
  }

  for (int i = 0; i < books.length; i += 3) {
    List<Widget> row = [];
    for (int j = i; j < i + 3; j++) {
      if (j >= books.length) {
        row.add(SizedBox(
          width: 100,
        ));
      } else {
        row.add(Column(children: [
          GestureDetector(
              onTap: () {
                onGroupPressed();
              },
              child: Image(
                image: NetworkImage(books[j]),
                width: 100,
                height: 120,
              )),
          SizedBox(
            height: 15,
          ),
          Text(
            groups[j].groupName,
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

  return Column(
    children: gridBooks,
  );
}
