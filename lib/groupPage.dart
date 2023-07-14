import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';


class GroupPage extends StatefulWidget {
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  @override
  Widget build(BuildContext context) {
    makeGrid(){
      List<Widget> a=[];
      a.add(Row(
        children:[
          Text("A"),
          Text("b"),
          Text("c"),
        ]
      ));

      return a;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Club'),
        elevation: 0.0,
        backgroundColor: colorScheme.color6,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ...makeGrid(),
        ],
      ),
    );
  }
}