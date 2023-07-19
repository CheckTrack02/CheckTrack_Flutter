import 'package:flutter/material.dart';
import 'package:checktrack/system/utilsSystem.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/db/BookEntity.dart';
import 'package:checktrack/timer/SelectBookPage.dart';
import 'package:checktrack/system/SocketSystem.dart';
import 'package:checktrack/timer/TimerPage.dart';
import 'dart:math';
import 'package:checktrack/system/TimerSystem.dart';


class TimerStartPage extends StatefulWidget {
  final VoidCallback? onFlip;
  TimerStartPage({required this.onFlip});
  @override
  State<TimerStartPage> createState() => _TimerStartPageState();
}

class _TimerStartPageState extends State<TimerStartPage> {

  late BookEntity bookEntity;
  late String bookImage;
  void setBookEntity() async{
    UserEntity userEntity = APISystem.getUserEntity();
    List<BookEntity> bookList = await BookAPISystem.getReadingBookList(userEntity.userNo);
    //print(bookList.length);
    if(bookList.isNotEmpty){
      if(mounted){
        setState((){
          bookEntity = bookList[0];
          bookImage = bookList[0].bookImage;
        });
      }
    }
  }
  _TimerStartPageState(){
    bookImage = "https://media.istockphoto.com/id/508545844/photo/question-mark-from-books-searching-information-or-faq-edication.jpg?s=612x612&w=0&k=20&c=-RTL7PuuaYZWifHcE4lvNFjqPY_J9VpqMNegcc3sdgA=";
    //SocketSystem.initSocket();
    setBookEntity();
  }

  //BookEntity bookEntity = getBookEntity()

  @override
  Widget build(BuildContext context) {
    
    void selectBook() async{
        final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SelectBookPage(),
        ));

        //print(result);
        if(mounted){
          setState((){
            if(result!=null){
              bookEntity = result;
              bookImage = result.bookImage;
            }
          });
        }
    }

    void startBookTimer() async{
      if(bookImage == "https://media.istockphoto.com/id/508545844/photo/question-mark-from-books-searching-information-or-faq-edication.jpg?s=612x612&w=0&k=20&c=-RTL7PuuaYZWifHcE4lvNFjqPY_J9VpqMNegcc3sdgA="){
        return;
      }
      final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => TimerPage(bookEntity: bookEntity),
      ));

      TimerSystem.finishTimer();
      SocketSystem.disconnectSocket();
      
      int userNo = APISystem.getUserEntity().userNo; 
      int bookNo = bookEntity.bookNo; 
      int userTime = TimerSystem.currentTime;
      int userPage = min(TimerSystem.currentPage, bookEntity.bookPageNum);
      String bookType = "Reading";
      if(userPage == bookEntity.bookPageNum){
        bookType = "Finished";
      }
      UserBookAPISystem.updateUserBookEntity(userNo, bookNo, userTime, userPage, bookType);
      print(result);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Timer'),
        elevation: 0.0,
        backgroundColor: colorScheme.color6,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow:[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          )
                        ]
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: Image(
                        image: NetworkImage(bookImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: IconButton(
                  icon: Icon(Icons.timer, color: colorScheme.color6),
                  iconSize: 70,
                  onPressed: (){
                    startBookTimer();
                  }
                ),
              )
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: const ShapeDecoration(
                  color: colorScheme.color3,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.white,),
                  iconSize: 40,
                  onPressed: (){
                      startBookTimer();
                  }
                ),
              )
            ),
            Positioned(
              width: 50,
              left: MediaQuery.of(context).size.width * 0.5 - 25,
              top: MediaQuery.of(context).size.height * 0.07,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]
                ),
                child: IconButton(
                  icon: Icon(Icons.bookmarks, color: colorScheme.color3),
                  iconSize: 30,
                  onPressed: (){
                    selectBook();
                  }
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}