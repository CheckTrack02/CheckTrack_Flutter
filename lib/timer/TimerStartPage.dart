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
  TimerStartPage();
  @override
  State<TimerStartPage> createState() => _TimerStartPageState();
}

class _TimerStartPageState extends State<TimerStartPage> {

  late BookEntity bookEntity;
  late String bookImage;
  void setBookEntity() async{
    UserEntity userEntity = await APISystem.initUserEntity();
    List<BookEntity> bookList = await BookAPISystem.getReadingBookList(userEntity.userNo);
    //print(bookList.length);
    if(bookList.isNotEmpty){
      setState((){
          bookEntity = bookList[0];
          bookImage = bookList[0].bookImage;
      });
    }
  }
  _TimerStartPageState(){
    bookImage = "https://media.istockphoto.com/id/508545844/photo/question-mark-from-books-searching-information-or-faq-edication.jpg?s=612x612&w=0&k=20&c=-RTL7PuuaYZWifHcE4lvNFjqPY_J9VpqMNegcc3sdgA=";
    SocketSystem.initSocket();
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
        setState((){
          if(result!=null){
            bookEntity = result;
            bookImage = result.bookImage;
          }
        });
    }

    void startBookTimer() async{
      final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => TimerPage(bookEntity: bookEntity),
      ));
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
          color: colorScheme.color1,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Image(
                  
                  image: NetworkImage(bookImage)
                ),
              )
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: const ShapeDecoration(
                  color: colorScheme.color6,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.play_arrow, color: colorScheme.color1),
                  iconSize: 30,
                  onPressed: (){
                      startBookTimer();
                  }
                ),
              )
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.1,
              child: IconButton(
                icon: Icon(Icons.bookmarks, color: Colors.brown),
                iconSize: 30,
                onPressed: (){
                  selectBook();
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}