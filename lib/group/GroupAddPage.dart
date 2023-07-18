import 'package:checktrack/db/BookEntity.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/system/utilsSystem.dart';

class GroupAddPage extends StatefulWidget {
  final int userNo;

  GroupAddPage({required this.userNo});

  @override
  State<GroupAddPage> createState() => _GroupAddPageState(userNo);
}

class _GroupAddPageState extends State<GroupAddPage> {
  
  final int userNo;

  _GroupAddPageState(this.userNo){
    bookController.text = "책을 선택하세요";
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController bookController = TextEditingController();
  
  BookEntity? selectedBook;
  List<UserEntity> members = [];



  @override
  Widget build(BuildContext context) {

    Widget contentAdd(Icon icon, String hinttext){
      Widget contentWidget = 
        Padding(
          padding: const EdgeInsets.only(left:8.0, right:8.0, top:20.0, bottom: 20.0),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
              child: Row(children: [
                icon,
                SizedBox(width: 10,),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: hinttext,
                    border: InputBorder.none,),
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  ),
                ),
              ],
              ),
            )
          ),
        );

      return contentWidget;
    }

    Widget dateAdd(Icon icon, TextEditingController controller) {
      controller.text =  DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
      return StatefulBuilder(
        builder: (context, setState) {
          Widget contentWidget = Padding(
            padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                child: Row(
                  children: [
                    icon,
                    SizedBox(width: 10,),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: TextButton(
                        child: Text(
                          controller.text,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: colorScheme.color3,
                                  colorScheme: ColorScheme.light(
                                    primary: colorScheme.color3, // 선택된 날짜의 색상
                                    onPrimary: Colors.white, // 선택된 날짜의 텍스트 색상
                                    surface: colorScheme.color3, // 캘린더의 배경색
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              controller.text = formattedDate;
                              print(controller.text);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          return contentWidget;
        },
      );
    }

    Widget bookAdd(Icon icon, TextEditingController bookController) {
      List<BookEntity> bookList = [];
      TextEditingController searchController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          Widget contentWidget = Padding(
            padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                child: Row(
                  children: [
                    icon,
                    SizedBox(width: 10,),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: TextButton(
                        child: Text(
                          bookController.text,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      width: 300,
                                      height: 250,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 20),
                                              SizedBox(
                                                width: 200,
                                                height: 30,
                                                child: TextField(
                                                  controller: searchController,
                                                  decoration: InputDecoration(
                                                    hintText: '책 제목을 검색하세요',
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  List<BookEntity> updatedBookList =
                                                      await BookAPISystem.getSearchBookEntity(
                                                          searchController.text);
                                                  setState(() {
                                                    bookList = updatedBookList;
                                                  });
                                                },
                                                icon: Icon(Icons.search),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Expanded(
                                            child: ListView.builder(
                                              physics: AlwaysScrollableScrollPhysics(),
                                              itemCount: bookList.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                BookEntity book = bookList[index];
                                                return ListTile(
                                                  leading: Image.network(book.bookImage),
                                                  title: Text(book.bookName),
                                                  subtitle: Text(book.bookAuthor),
                                                  onTap: (){
                                                    setState(() {
                                                      selectedBook = book;
                                                      bookController.text = book.bookName;
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                          setState(() {
                            bookController.text = selectedBook!.bookName;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          return contentWidget;
          
        }
      );
    }



    Widget groupAdd() {
      Widget groupAddWidget = Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 20.0, right: 20.0),
        child: Column(
              children: [
                SizedBox(height: 50,),
                Text("CREATING GROUP", 
                  style: TextStyle(color: colorScheme.color4,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                contentAdd(Icon(Icons.group), "독서 모임 이름을 정해주세요"),
                dateAdd(Icon(Icons.calendar_month), startController),
                dateAdd(Icon(Icons.calendar_month), endController),
                bookAdd(Icon(Icons.book), bookController),
                SizedBox(height: 40,),
                SizedBox(
                  height: 50, width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text == "" || selectedBook == Null){
                      return;
                    }
                    print("post button");
                    int groupNo = await GroupAPISystem.postGroupEntity(nameController.text, selectedBook!.bookNo, startController.text, endController.text);
                    int statusCode = await GroupAPISystem.postGroupUser(userNo, groupNo, selectedBook!.bookNo);
                    if (statusCode == 200) {
                      Navigator.pop(context);
                    }
                    }, 
                    child: Text("독서 모임 시작", 
                      style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.color3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ) 
                    )
                  ),
                )
              ]
            )
          );
      return groupAddWidget;
    }

    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.group_add),
        elevation: 0.0,
        backgroundColor: colorScheme.color4,
        centerTitle: true,
      ),
      body: GestureDetector(     
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView( 
          child: groupAdd(),
        )
      ),
    );

  }
}