import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';

class GroupPage extends StatefulWidget {
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  @override
  Widget build(BuildContext context) {
    List<String> books = ['assets/images/literature.png', 'assets/images/literature.png', 'assets/images/literature.png', 'assets/images/literature.png', 'assets/images/literature.png'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  hintText: '도서명을 입력해주세요',
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: makeGrid(books),
        ),
      );
  }
}

Column makeGrid(List<String> books){
  List<Widget> grid_books = [];

  for (int i = 0; i < books.length; i += 3){
    List<Widget> row = [];
    for (int j = i; j < i + 3; j++){
      if (j >= books.length){
        row.add(SizedBox(width: 100,));
      }
      else{
        row.add(Image(
          image: AssetImage(books[j]),
          width: 100,
          height: 120,
        ));
      }
    }
    grid_books.add(
      Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [...row],
        ),
      )
    );
  }

  return Column(
    children: grid_books,
    );
}
