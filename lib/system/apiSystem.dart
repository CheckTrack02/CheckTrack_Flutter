import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:checktrack/db/GroupEntity.dart';
import 'package:checktrack/db/UserEntity.dart';
import 'package:checktrack/db/GroupUserEntity.dart';
import 'package:checktrack/db/BookEntity.dart';
import 'package:checktrack/db/IssueEntity.dart';

const int PORT_NO = 80;
const String httpUrl = "http://172.10.5.144:${PORT_NO}";

class APISystem{
  static Future<dynamic> getResponse(String httpPath, String queryType, data) async{
    final String url = httpUrl + httpPath;
    if(queryType == "GET"){
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type' : 'application/json',
        },
      );
      return response;
    }
    if(queryType == "POST"){
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type' : 'application/json',
        },
        body: jsonEncode(data),
      );
      return response;
    }
    return null;
  }
}

class UserAPISystem{
  static Future<int> fetchUser(String user_id, String user_pw) async {
    final response = await APISystem.getResponse("/login", "POST", {
      "user_id": user_id,
      "user_pw": user_pw
    });
    return response.statusCode;
  }
  static Future<UserEntity> getUserEntity(int userNo) async{
    final response = await APISystem.getResponse("/user/get-user-entity?userNo=${userNo}", "GET", null);
    //print(response.body);
    return UserEntity(
      userNo: jsonDecode(response.body)['userNo'], 
      userId: jsonDecode(response.body)['userId'], 
      userName: jsonDecode(response.body)['userName'], 
      userPw: jsonDecode(response.body)['userPw']
    );
  }
  static Future<List<UserEntity>> getGroupUserList(int groupNo) async{
    final response = await APISystem.getResponse("/user/get-group-user-no-list?groupNo=${groupNo}", "GET", null);
    List<UserEntity> userList = [];
    List<dynamic> userNoList = jsonDecode(response.body);
    for(int i = 0; i < userNoList.length; i++){
      int userNo = userNoList[i]['userNo'];
      userList.add(await UserAPISystem.getUserEntity(userNo));
    }
    return userList;
  }
  static Future<GroupUserEntity> getGroupUserEntity(int userNo, int groupNo) async{
    final response = await APISystem.getResponse("/user/get-group-user-entity?userNo=${userNo}&groupNo=${groupNo}", "GET", null);
    return GroupUserEntity(
      groupNo: jsonDecode(response.body)['groupNo'],
      userNo: jsonDecode(response.body)['userNo'],
      userPage: jsonDecode(response.body)['userPage'],
      userTime: jsonDecode(response.body)['userTime']
    );
  }
}

class GroupAPISystem{
  static Future<GroupEntity> getGroupEntity(int groupNo) async{
    final response = await APISystem.getResponse("/group/get-group-entity?groupNo=${groupNo}", "GET", null);
    //print(response.body);
    return GroupEntity(
      groupBookNo: jsonDecode(response.body)['groupBookNo'], 
      groupEndDate: DateTime.parse(jsonDecode(response.body)['groupEndDate']), 
      groupNo: jsonDecode(response.body)['groupNo'], 
      groupName: jsonDecode(response.body)['groupName'], 
      groupStartDate: DateTime.parse(jsonDecode(response.body)['groupStartDate'])
    );
  }

  static Future<List<GroupEntity>> getUserGroupList (int userNo) async{
    final response = await APISystem.getResponse("/group/get-user-group-no-list?groupNo=${userNo}", "GET", null);
    List<GroupEntity> groupList = [];
    List<dynamic> groupNoList = jsonDecode(response.body);
    for(int i = 0; i < groupNoList.length; i++){
      int groupNo = groupNoList[i]['groupNo'];
      groupList.add(await GroupAPISystem.getGroupEntity(groupNo));
    }
    return groupList;
  }
}


class BookAPISystem{
  static Future<BookEntity> getBookEntity (int bookNo) async{
    final response = await APISystem.getResponse("/book/get-book-entity?bookNo=${bookNo}", "GET", null);
    return BookEntity(
      bookNo: jsonDecode(response.body)['bookNo'],
      bookName: jsonDecode(response.body)['bookName'],
      bookAuthor: jsonDecode(response.body)['bookAuthor'],
      bookImage: jsonDecode(response.body)['bookImage'],
      bookPageNum: jsonDecode(response.body)['bookPageNum'],
    );
  }
}

class IssueAPISystem{
  static Future<IssueEntity> getIssueEntity (int issueNo) async{
    final response = await APISystem.getResponse("/issue/get-issue-entity?issueNo=${issueNo}", "GET", null);
    return IssueEntity(
      issueNo: jsonDecode(response.body)['issueNo'],
      issueTitle: jsonDecode(response.body)['issueTitle'],
      issueContext: jsonDecode(response.body)['issueContext'],
      issueUserNo: jsonDecode(response.body)['issueUserNo'],
      issueDate: DateTime.parse(jsonDecode(response.body)['issueDate']),
      issueGroupNo: jsonDecode(response.body)['issueGroupNo'],
    );
  }
  static Future<List<IssueEntity>> getGroupIssueList (int groupNo) async{
    final response = await APISystem.getResponse("/issue/get-group-issue-list?groupNo=${groupNo}", "GET", null);
    List<IssueEntity> issueList = [];
    List<dynamic> res = jsonDecode(response.body);
    for(int i=0; i<res.length; i++){
      issueList.add(IssueEntity(
        issueNo: res[i]['issueNo'],
        issueTitle: res[i]['issueTitle'],
        issueContext: res[i]['issueContext'],
        issueUserNo: res[i]['issueUserNo'],
        issueDate: DateTime.parse(res[i]['issueDate']),
        issueGroupNo: res[i]['issueGroupNo'],
      ));
    }
    return issueList;
  }
}


