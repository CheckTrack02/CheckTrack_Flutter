import 'package:checktrack/system/apiSystem.dart';
import 'package:checktrack/db/BookEntity.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:checktrack/db/UserBookEntity.dart';
import 'dart:math';
class TimerSystem{
  static bool isTimerStart = false;
  static late BookEntity bookEntity;
  static int currentDuration = 0;
  static int currentTime = 0;
  static int recentTime = 0;
  static int recentPage = 0;
  static int currentPage = 0;
  static Map groupUserMap = {};
  static Map roomUserList = {};
  static int currentStartTime = 0;
  static bool loadList = false;

  static void updateUser(String userName, int userTime, int userPage, int startTime){
    if(!isTimerStart || !loadList){
      return;
    }
    String addUserName = userName;
    int addDuration = (DateTime.now().millisecondsSinceEpoch - startTime) ~/ 1000;
    int addUserTime = userTime + addDuration;
    int addUserPage = userPage;
    print("UPDATE : $userName");
    if(userTime!=0){
      addUserPage = min(bookEntity.bookPageNum, (userPage * addUserTime) ~/ userTime);
    }
    Map roomUserMap = {
      'recentUserTime' : addUserTime - currentDuration,
      'recentUserPage' : addUserPage - ((userPage * currentDuration) ~/ userTime),
      'userTime' : addUserTime,
      'userPage' : addUserPage
    };
    roomUserList[addUserName] = roomUserMap;
    if(groupUserMap.containsKey(addUserName)){
      print("IN GROUP");
      Map userMap = {
        'recentUserTime' : addUserTime - currentDuration,
        'recentUserPage' : userPage - ((userPage * currentDuration) ~/ userTime),
        'userTime' : addUserTime,
        'userPage' : addUserPage,
        'isInList' : true,
      };
      groupUserMap[addUserName] = userMap;
    }
  }
  static late List<Map> updateList;

  static void setGroupUserList() async{
    loadList = false;
    groupUserMap = {};
    int userNo = APISystem.getUserEntity().userNo;
    int bookNo = bookEntity.bookNo;
    List<int> groupList = await GroupAPISystem.getUserBookGroupNoList(userNo, bookNo);
    print("Group List");
    for(int i=0 ;i<groupList.length; i++){
      print(groupList[i]);
    }
    List<UserEntity> userList = await UserAPISystem.getGroupListUserList(groupList);
    print("User List");
    for(int i=0; i<userList.length; i++){
      print(userList[i].userName);
    }
    List<UserBookEntity> userBookList = await UserBookAPISystem.getUserListUserBookList(userList, bookNo);
    print("USER BOOK LIST");
    for(int i=0; i<userBookList.length; i++){
      print(userList[i].userName + " " + userBookList[i].userTime.toString() + " " + userBookList[i].userPage.toString());
    }
    for(int i=0; i<userList.length; i++){
      String userName = userList[i].userName;
      if(userName==APISystem.myUserEntity.userName) {
        continue;
      }
      Map userMap = {
        'userTime': userBookList[i].userTime,
        'userPage': userBookList[i].userPage,
        'isInList': false
      };
      groupUserMap[userName] = userMap;
      print("Group User Map Added " + userName);
    }
    loadList = true;
  }

  static String timeToString(int _time){
    return "${(_time/3600%60).toInt().toString().padLeft(2, "0")}:${(_time/60%60).toInt().toString().padLeft(2, "0")}:${(_time%60).toInt().toString().padLeft(2, "0")}";
  }

  static void initUserList(Map roomInfo){
    if(!isTimerStart){
      return;
    }
    List<String> roomUserNameList = roomInfo['roomUserNameList'].cast<String>();
    List<int> roomUserTimeList = roomInfo['roomUserTimeList'].cast<int>();
    List<int> roomUserPageList = roomInfo['roomUserPageList'].cast<int>();
    updateList = [];
    for(int i=0; i<roomUserNameList.length; i++){
      print("INIT USER " + roomUserNameList[i]);
      Map userMap = {
        'userName' : roomUserNameList[i],
        'userTime' : roomUserTimeList[i],
        'userPage' : roomUserPageList[i],
        'startTime' : currentStartTime,
      };
      updateList.add(userMap);
    }
  }

  static void checkUpdateList(){
    if(!isTimerStart || !loadList){
      return;
    }
    while(updateList.isNotEmpty){
      Map userMap = updateList[updateList.length-1];
      String userName = userMap['userName'];
      int userTime = userMap['userTime'];
      int userPage = userMap['userPage'];
      int startTime = userMap['startTime'];
      updateUser(userName, userTime, userPage, startTime);
      updateList.removeAt(updateList.length-1);
    }
  }

  static void removeUser(String userName, int userTime, int userPage, int startTime){
    if(!isTimerStart || !loadList){
      return;
    }
    String removeUserName = userName;
    int removeDuration = (DateTime.now().millisecondsSinceEpoch - startTime) ~/ 1000;
    int removeUserTime = userTime + removeDuration;
    int removeUserPage = min(bookEntity.bookPageNum, userPage);
    if(userTime!=0){
      removeUserPage = min(bookEntity.bookPageNum, (userPage * removeUserTime) ~/ userTime);
    }
    roomUserList.remove(removeUserName);

    if(groupUserMap.containsKey(removeUserName)){
      print("REMOVE: IN GROUP");
      Map userMap = {
        'userTime': removeUserTime,
        'userPage': removeUserPage,
        'isInList': false
      };
      groupUserMap[removeUserName] = userMap;
      print("Group User Map Removed " + userName);
    }
  }
  static void finishTimer(){
    groupUserMap = {};
    roomUserList = {};
    isTimerStart = false;
  }
}