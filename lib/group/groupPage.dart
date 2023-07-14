import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';

class GroupPage extends StatefulWidget {
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  @override
  Widget build(BuildContext context) {
    List<String> books = ['assets/images/book1.jpg', 'assets/images/book2.jpg', 'assets/images/book3.jpg', 'assets/images/book4.jpg'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.color6,
        title: Row(
          children: [
            Icon(Icons.people,),
            SizedBox(width: 15,),
            Text(
              "Reading Group", 
              style: TextStyle(color: Colors.white)
            ),
          ],
        )
        
      ),
      body: makeGrid(books),
      );
  }
}

Column makeGrid(List<String> books){
  List<Widget> gridBooks = [];

  for (int i = 0; i < books.length; i += 3){
    List<Widget> row = [];
    for (int j = i; j < i + 3; j++){
      if (j >= books.length){
        row.add(SizedBox(width: 100,));
      }
      else{
        row.add(Column(
          children: [
            Image(
              image: AssetImage(books[j]),
              width: 100,
              height: 120,
            ),
            SizedBox(height: 15, ),
            Text("group",
              style: TextStyle(),
            ),
          ]
          
        ));
      }
    }
    gridBooks.add(
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
    children: gridBooks,
    );
}
